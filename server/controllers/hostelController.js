const jwt = require('jsonwebtoken');
const User = require('../models/user');
const Hostel = require('../models/hostel');
const Review = require('../models/review');
const Analytics = require('../models/analytics');
const QueryHandler = require('../utils/queryHandler');
const cloudinary = require('cloudinary');
const upload = require('../utils/multerConfig');
const { handleCloudinaryUpload, deleteFromCloudinary } = require('../utils/cloudinaryUtils');

// Multer middleware for uploading user photo and document
exports.uploadHostelPhoto = upload.fields([
  { name: 'images', maxCount: 10 },
  { name: 'document', maxCount: 1 },
]);

/*
    @desc gets token from request header
    @access Private
*/
const getToken = (req) => {
  const { token } = req.cookies;
  console.log('token', token);
  if (token) {
    return token;
  }
  return null;
};

/*
    @route GET /api/hostels
    @desc Get all hostels
    @access Public
*/
exports.get_hostels = async (req, res, next) => {
  try {
    const queryhandler = new QueryHandler(Hostel.find(), req.query)
      .locate()
      .search()
      .filter()
      .sort()
      .pagination(10);
    const hostels = await queryhandler.query;
    res.status(200).json(hostels);
  } catch (err) {
    next(err);
  }
};

/*
    @route GET /api/hostels/:id
    @desc Get a hostel
    @access Public
*/
// exports.get_hostel = async (req, res, next) => {
//   try {
//     const hostel = await Hostel.findById(req.params.id);
//     res.status(200).json(hostel);
//   } catch (err) {
//     next(err);
//   }
// };

exports.get_hostel = async (req, res, next) => {
  try {
    const ownerId = req.params.id;

    // Find the hostel where the owner ID matches
    const hostel = await Hostel.find({ owner: ownerId });

    // If the hostel is not found, return an error response
    if (!hostel) {
      return res.status(404).json({
        status: 'error',
        message: 'Hostel not found',
      });
    }

    // Return the hostel details
    res.status(200).json({
      status: 'success',
      data: hostel,
    });
  } catch (err) {
    next(err);
  }
};

/*
    @route POST /api/hostels/register
    @desc Register a new hostel
    @access Public
*/

exports.register_hostel = async (req, res, next) => {
  let hostel;
  try {
    const body = req.body;
    const { images, document } = req.files || {};
    console.log('Yo hostel ko register body:', body);
    console.log('Yo hostel ko image:', images);
    let documentCloudUrl = null;
    const imagesClourUrl = [];

    const token = getToken(req);
    const decodedToken = jwt.verify(token, process.env.SECRET);

    // console.log('decodedToken', decodedToken);

    if (!token || !decodedToken.id) {
      return res.status(401).json({ error: 'token missing or invalid' });
    }

    const user = await User.findById(decodedToken.id);

    if (document) {
      documentCloudUrl = await handleCloudinaryUpload(
        document[0].buffer,
        'tempDoc.jpg',
        'documents',
        `document_${Date.now()}`
      );
    }

    if (images) {
      for (let i = 0; i < images.length; i++) {
        imagesClourUrl[i] = await handleCloudinaryUpload(
          images[i].buffer,
          'tempImg.jpg',
          'hostelImages',
          `${user.username}_image_${i + 1}`
        );
      }
    }

    hostel = new Hostel({
      name: body.name,
      address: body.address,
      location: {
        type: 'Point',
        coordinates: [body.latitude, body.longitude],
      },
      description: body.description,
      for_gender: body.for_gender,
      document: documentCloudUrl,
      images: imagesClourUrl || [],
      verified: body.verified,
      owner: user._id,
      amenities: body.amenities || [],
      rooms: body.rooms || [],
      reviews: [],
    });

    await hostel.compute_availability();

    const savedHostel = await hostel.save();
    user.hostel_listings = user.hostel_listings.concat(savedHostel._id);
    await user.save();

    // now update the analytics
    const analytics = await Analytics.findOne({ 'date.year': new Date().getFullYear() });
    if (analytics) {
      const month = new Date().getMonth();
      analytics.date.month[month].registrations += 1;
      await analytics.save();
    } else {
      const newAnalytics = new Analytics({
        date: {
          year: new Date().getFullYear(),
          month: Array.from({ length: 12 }, () => ({
            visits: 0,
            registrations: 0,
            interactions: 0,
          })),
        },
      });
      const month = new Date().getMonth();
      newAnalytics.date.month[month].registrations += 1;
      await newAnalytics.save();
    }

    res.status(201).json({
      status: 'success',
      data: savedHostel,
    });
  } catch (err) {
    if (hostel) {
      // If there was an error saving the hostel, delete the uploaded
      // hostel images and document from Cloudinary
      if (hostel.images) {
        for (let i = 0; i < hostel.images.length; i++) {
          await deleteFromCloudinary(hostel.images[i]);
        }
      }

      if (hostel.document) {
        await deleteFromCloudinary(hostel.document);
      }
    }

    next(err);
  }
};

/*
    @route PATCH /api/hostels/:id
    @desc Update a hostel
    @access Owner
*/
exports.update_hostel = async (req, res, next) => {
  try {
    const body = req.body;
    const token = getToken(req);
    const decodedToken = jwt.verify(token, process.env.SECRET);

    if (!token || !decodedToken.id) {
      return res.status(401).json({ error: 'token missing or invalid' });
    }

    const user = await User.findById(decodedToken.id);
    const hostel = await Hostel.findById(req.params.id);

    if (hostel.owner.toString() === user.id.toString()) {
      // Update only the specified fields from the request body
      const { amenities, available_rooms, rooms, description, for_gender } = body;

      // Check if the fields are present in the request body, and update them if so
      if (amenities) {
        hostel.amenities = amenities;
      }

      if (available_rooms) {
        hostel.available_rooms = available_rooms;
      }

      if (rooms) {
        hostel.rooms = rooms;
      }

      if (description) {
        hostel.description = description;
      }

      if (for_gender) {
        hostel.for_gender = for_gender;
      }

      // Save the updated hostel
      const updatedHostel = await hostel.save();

      res.status(200).json(updatedHostel);
    }
  } catch (err) {
    next(err);
  }
};

// exports.update_hostel = async (req, res, next) => {
//   try {
//     const body = req.body;

//     const token = getToken(req);
//     const decodedToken = jwt.verify(token, process.env.SECRET);

//     if (!token || !decodedToken.id) {
//       return res.status(401).json({ error: 'token missing or invalid' });
//     }

//     const user = await User.findById(decodedToken.id);
//     const hostel = await Hostel.findById(req.params.id);

//     if (hostel.owner.toString() === user.id.toString()) {
//       /* need to learn about the runValidators and useFindAndModify options */
//       /* front end will send object as a whole to update */
//       const updatedHostel = await Hostel.findByIdAndUpdate(req.params.id, body, {
//         new: true,
//         runValidators: true,
//         useFindAndModify: false,
//       });
//       res.status(200).json(updatedHostel);
//     }
//   } catch (err) {
//     next(err);
//   }
// };

/*
    @route PUT /api/hostels/:id
    @desc post review for a hostel
    @access Private
*/
exports.post_review = async (req, res, next) => {
  try {
    const body = req.body;

    const token = getToken(req);
    const decodedToken = jwt.verify(token, process.env.SECRET);

    if (!token || !decodedToken.id) {
      return res.status(401).json({ error: 'token missing or invalid' });
    }

    const user = await User.findById(decodedToken.id);
    console.log(user);
    const hostel = await Hostel.findById(req.params.id).populate('reviews');
    console.log(hostel);
    const review = new Review({
      cleanliness: Number(body.cleanliness),
      food: Number(body.food),
      staff: Number(body.staff),
      amenities: Number(body.amenities),
      overall_rating: Number(
        (Number(body.cleanliness) +
          Number(body.food) +
          Number(body.staff) +
          Number(body.amenities)) /
          4
      ),
      comment: body.comment,
      user: user._id,
      hostel: hostel._id,
    });

    const savedReview = await review.save();
    hostel.reviews = hostel.reviews.concat(savedReview._id);
    await hostel.compute_rating(review.overall_rating);
    await hostel.compute_ranking();
    await hostel.save();
    user.reviews = user.reviews.concat(savedReview._id);
    await user.save();
    res.status(200).json(savedReview);
  } catch (err) {
    next(err);
  }
};

/*
    @route update review /review/update/:id
    @desc update review for a hostel
    @access Private
*/

exports.update_review = async (req, res, next) => {
  try {
    const body = req.body;

    const token = getToken(req);
    const decodedToken = jwt.verify(token, process.env.SECRET);

    if (!token || !decodedToken.id) {
      return res.status(401).json({ error: 'token missing or invalid' });
    }

    const user = await User.findById(decodedToken.id);
    const review = await Review.findById(req.params.id);

    if (review.user.toString() === user.id.toString()) {
      const updatedReview = {
        ...body,
        overall_rating: Number(
          (Number(body.cleanliness) +
            Number(body.food) +
            Number(body.staff) +
            Number(body.amenities)) /
            4
        ),
      };
      const savedReview = await Review.findByIdAndUpdate(req.params.id, updatedReview, {
        new: true,
        runValidators: true,
        useFindAndModify: false,
      });

      // update the analytics
      const analytics = await Analytics.findOne({ 'date.year': new Date().getFullYear() });
      if (analytics) {
        const month = new Date().getMonth();
        analytics.date.month[month].interactions += 1;
        await analytics.save();
      } else {
        const newAnalytics = new Analytics({
          date: {
            year: new Date().getFullYear(),
            month: Array.from({ length: 12 }, () => ({
              visits: 0,
              registrations: 0,
              interactions: 0,
            })),
          },
        });
        const month = new Date().getMonth();
        newAnalytics.date.month[month].interactions += 1;
        await newAnalytics.save();
      }

      res.status(200).json(savedReview);
    }
  } catch (err) {
    next(err);
  }
};

// verify
exports.verify_hostel = async (req, res, next) => {
  try {
    const hostel = await Hostel.findById(req.params.id);
    hostel.verified = true;
    await hostel.save();
    res.status(200).json(hostel);
  } catch (err) {
    next(err);
  }
};

exports.unverify_hostel = async (req, res, next) => {
  try {
    const hostel = await Hostel.findById(req.params.id);
    hostel.verified = false;
    await hostel.save();
    res.status(200).json(hostel);
  } catch (err) {
    next(err);
  }
};

/*
    @route GET /api/hostels/featured
    @desc Get all hostels that might be featured or top rated
    @access Public
*/
exports.get_featured_hostels = async (req, res, next) => {
  try {
    const hostels = await Hostel.find({ featured: true }).populate('owner').limit(3);
    res.status(200).json({
      status: 'success',
      data: hostels,
    });
  } catch (err) {
    next(err);
  }
};

/* 
    @route UNFEATURE /api/hostels/unfeatured/:id
    @desc unfeature a hostel
    @access Admin
*/
exports.unfeature_hostel = async (req, res, next) => {
  try {
    const hostel = await Hostel.findById(req.params.id);
    hostel.featured = false;
    await hostel.save();
    res.status(200).json(hostel);
  } catch (err) {
    next(err);
  }
};

/*
    @route FEATURE /api/hostels/featured/:id
    @desc feature a hostel
    @access Admin
*/
exports.feature_hostel = async (req, res, next) => {
  try {
    const hostel = await Hostel.findById(req.params.id);
    hostel.featured = true;
    await hostel.save();
    res.status(200).json(hostel);
  } catch (err) {
    next(err);
  }
};

/*
    @route UNFEATURE ALL /api/hostels/unfeatured
    @desc unfeature all hostels
    @access Admin
*/
exports.unfeature_all_hostels = async (req, res, next) => {
  try {
    const hostels = await Hostel.find({ featured: true });
    hostels.forEach(async (hostel) => {
      hostel.featured = false;
      await hostel.save();
    });
    res.status(200).json(hostels);
  } catch (err) {
    next(err);
  }
};

/*
    @route GET /api/hostels/all
    @desc Get all hostels
    @access Public
*/
exports.get_all_hostels = async (req, res, next) => {
  try {
    const hostels = await Hostel.find({}).populate('owner').sort({ ranking: -1 });
    res.status(200).json(hostels);
  } catch (err) {
    next(err);
  }
};

/*
    @route UNVERIFIED HOSTELS /api/hostels/unverified
    @desc Get all unverified hostels
    @access Admin
*/
exports.get_unverified_hostels = async (req, res, next) => {
  try {
    const hostels = await Hostel.find({ verified: false }).populate('owner');
    res.status(200).json(hostels);
  } catch (err) {
    next(err);
  }
};

/*
    @route DELETE /api/hostels/delete/:id
    @desc Delete a hostel
    @access Owner
*/
exports.delete_hostel = async (req, res, next) => {
  try {
    const hostel = await Hostel.findById(req.params.id);
    const hostelOwner = await User.findById(hostel.owner);
    const reviews = await Review.find({ hostel: req.params.id });

    await Promise.all(
      reviews.map((review) => {
        User.findByIdAndUpdate(review.user, { $pull: { reviews: review._id } });
        review.remove();
      })
    );
    User.findByIdAndUpdate(hostelOwner._id, { $pull: { hostels: hostel._id } });
    await hostel.remove();
    res.status(200).json({
      status: 'success',
      message: 'Hostel deleted successfully',
    });
  } catch (err) {
    next(err);
  }
};
