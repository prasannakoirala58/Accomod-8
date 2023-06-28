const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
// const fs = require('fs');
// const path = require('path');
const { promisify } = require('util');
const User = require('../models/user');
const Hostel = require('../models/hostel');
const Review = require('../models/review');
const crypto = require('crypto');
const Email = require('../utils/mailing');
const cloudinary = require('cloudinary');
const upload = require('../utils/multerConfig');
const { handleCloudinaryUpload, deleteFromCloudinary } = require('../utils/cloudinaryUtils');
const { CreateError } = require('../utils/CreateError');

// Multer middleware for uploading user photo and document
exports.uploadUserPhoto = upload.fields([
  { name: 'profile_picture', maxCount: 1 },
  { name: 'document', maxCount: 2 },
]);

/*
    @desc gets token from request header
    @access Private
*/
const getToken = (req) => {
  const { token } = req.cookies;
  if (token) {
    return token;
  }
  return null;
};

/*
    @route GET /api/users/logout
    @desc Log Out a user
    @access Private
*/
exports.logout_user = (req, res, next) => {
  try {
    res.clearCookie('token');
    res.status(200).json({
      status: 'success',
      msg: 'User logged out successfully!',
    });
  } catch (err) {
    console.log('Yo logout ko error ho hai:', err);
    next(err);
  }
};

/*
    @route GET /api/users
    @desc Get all users
    @access Public
*/
exports.get_users = async (req, res, next) => {
  try {
    const users = await User.find({});
    res.status(200).json(users);
  } catch (err) {
    next(err);
  }
};

/*
    @route GET /api/users/:id
    @desc Get a user
    @access Public
*/
exports.get_user = async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id).populate('hostel_listings');
    res.status(200).json(user);
  } catch (err) {
    next(err);
  }
};

/*
    @route POST /api/users/register
    @desc Register a new user
    @access Public
*/
exports.register_user = async (req, res, next) => {
  let user;
  try {
    const body = req.body;
    const { profile_picture, document } = req.files || {};
    // console.log(body.username);

    let profileCloudUrl = null;
    let documentCloudUrl = null;

    if (profile_picture) {
      profileCloudUrl = await handleCloudinaryUpload(
        profile_picture[0].buffer,
        'tempPhoto.jpg',
        'avatars',
        `${body.username}_profile`
      );
    }

    if (document) {
      documentCloudUrl = await handleCloudinaryUpload(
        document[0].buffer,
        'tempDoc.jpg',
        'documents',
        `document_${Date.now()}`
      );
    }

    const saltRounds = 10;
    const passwordHash = bcrypt.hashSync(body.password, saltRounds);

    user = new User({
      username: body.username,
      email: body.email,
      passwordHash: passwordHash,
      usertype: {
        typeof_user: body.typeof_user,
      },
      profile: {
        first_name: body.first_name,
        middle_name: body.middle_name,
        last_name: body.last_name,
        gender: body.gender,
        phone_number: body.phone_number,
        address: body.address,
        profile_picture: profileCloudUrl ? profileCloudUrl : null,
        document: documentCloudUrl ? documentCloudUrl : null,
      },
      reviews: [],
      hostel_listings: [],
    });

    const savedUser = await user.save();
    res.status(200).json({
      status: 'success',
      data: savedUser,
    });
  } catch (err) {
    // console.log("Yo cloudinary ko error hota?", err);
    if (user) {
      // If there was an error saving the user, delete the uploaded profile picture and document from Cloudinary
      if (user.profile.profile_picture) {
        await deleteFromCloudinary(user.profile.profile_picture);
      }
      if (user.profile.document) {
        await deleteFromCloudinary(user.profile.document);
      }
    }

    next(err);
  }
};

/*
    @route POST /api/users/login
    @desc Login a user
    @access Public
*/
exports.login_user = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email }).select('+passwordHash');

    // console.log('Yo user ho hai:', user);

    const correctPassword =
      user === null ? false : await bcrypt.compare(password, user.passwordHash);

    if (!(user && correctPassword)) {
      return res.status(401).json({
        error: 'Invalid username or password',
      });
    }

    const userForToken = {
      username: user.username,
      id: user._id,
      isAdmin: user.usertype.typeof_user === 'admin' ? true : false,
    };

    const token = jwt.sign(userForToken, process.env.SECRET);

    const options = {
      expires: new Date(Date.now() + process.env.COOKIE_EXPIRES_IN * 24 * 60 * 60 * 1000),
      httpOnly: true,
    };

    res
      .status(200)
      .cookie('token', token, options)
      .send({
        status: 'success',
        data: {
          id: user._id,
          username: user.username,
          profile_picture: user.profile.profile_picture,
        },
      });
  } catch (err) {
    next(err);
  }
};

/*
    @route PUT /api/users/update/:id
    @desc Update a user
    @access Private
*/

// Filter out unwanted fields that are not allowed to be updated
const filterObj = (obj, ...allowedFields) => {
  const newObj = {};

  Object.keys(obj).forEach((el) => {
    if (allowedFields.includes(el)) newObj[el] = obj[el];
  });

  return newObj;
};

exports.update_user = async (req, res, next) => {
  try {
    const body = req.body;
    const { profile_picture } = req.files || {};

    // yo token req.cookies.token ma xa
    const token = getToken(req);
    const decodedToken = await promisify(jwt.verify)(token, process.env.SECRET);
    if (!token || !decodedToken.id) {
      return res.status(401).json({ error: 'token missing or invalid' });
    }

    const user = await User.findById(decodedToken.id);

    let filteredBody = filterObj(body, 'email');

    if (profile_picture) {
      if (user.profile.profile_picture) {
        const publicId = user.profile.profile_picture.split('/avatars/')[1].split('.')[0];
        await cloudinary.v2.uploader.destroy(`avatars/${publicId}`);
      }

      // Upload the new profile picture to Cloudinary
      profileCloudUrl = await handleCloudinaryUpload(
        profile_picture[0].buffer,
        'tempPhoto.jpg',
        'avatars',
        `${user.username}_profile`
      );

      filteredBody['profile.profile_picture'] = profileCloudUrl;
    }

    // console.log('filtered body', filteredBody);

    // 3 ) Update user document
    const updatedUser = await User.findByIdAndUpdate(
      req.user.id,
      // { $set: { ...body, ...filteredBody } },
      filteredBody,
      {
        new: true,
        runValidators: true,
      }
    );

    res.status(200).json({
      status: 'success',
      data: updatedUser,
    });
  } catch (err) {
    next(err);
  }
};

/*
    @route UPDATE PASSWORD /api/users/update/password/:id
    @desc Update a user's password
    @access Private
*/
exports.update_password = async (req, res, next) => {
  try {
    const body = req.body;

    const token = getToken(req);
    const decodedToken = jwt.verify(token, process.env.SECRET);
    if (!token || !decodedToken.id) {
      return res.status(401).json({ error: 'token missing or invalid' });
    }

    const user = await User.findById(decodedToken.id).select('+passwordHash');
    const correctPassword =
      user === null ? false : await bcrypt.compare(body.passwordCurrent, user.passwordHash);

    if (correctPassword) {
      if (body.password !== body.passwordConfirm) {
        return res.status(401).json({
          status: 'error',
          msg: 'Passwords do not match',
        });
      }
      const saltRounds = 10;
      const passwordHash = bcrypt.hashSync(body.password, saltRounds);
      const updatedUser = await User.findByIdAndUpdate(
        req.params.id,
        { passwordHash },
        {
          new: true,
          runValidators: true,
          useFindAndModify: false,
        }
      );
      res.status(200).json({
        status: 'success',
        data: updatedUser,
      });
    } else {
      res.status(401).json({
        status: 'error',
        msg: 'Incorrect password',
      });
    }
  } catch (err) {
    next(err);
  }
};

/*
    @route FORGOT PASSWORD /api/users/update/password/forgot
    @desc Send a user a password reset link
    @access Private
*/
exports.forgot_password = async (req, res, next) => {
  let user;
  try {
    const body = req.body;

    user = await User.findOne({ email: body.email });

    if (!user) {
      return next(new CreateError('There is no user with this email address.', 404));
    }

    // 2) Generate the random reset token
    const resetToken = await user.createPasswordResetToken();

    // this turns all the validators off for the user so that they can proceed to reset their password
    await user.save({ validateBeforeSave: false });

    /* mail options configured */
    const resetURL = `${req.protocol}://${req.get(
      'host'
    )}/api/users/resetPassword/${resetToken}`;

    const em = await new Email(user, resetURL).sendPasswordReset();

    res.status(200).json({
      status: 'success',
      message: 'Token sent to email!',
    });
  } catch (err) {
    user.passwordResetToken = undefined;
    user.passwordResetExpires = undefined;

    await user.save({ validateBeforeSave: false });

    return next(
      new CreateError('There was an error sending the email. Try again later!'),
      500
    );
  }
};

/*
    @route RESET PASSWORD /api/users/update/password/reset/:token
    @desc Reset a user's password
    @access Private
*/
exports.reset_password = async (req, res, next) => {
  try {
    const body = req.body;

    const passwordResetToken = crypto
      .createHash('sha256')
      .update(req.params.token)
      .digest('hex');

    const user = await User.findOne({
      passwordResetToken,
      passwordResetExpires: { $gt: Date.now() },
    });

    if (user) {
      const saltRounds = 10;
      const passwordHash = bcrypt.hashSync(body.new_password, saltRounds);
      const updatedUser = await User.findByIdAndUpdate(
        user._id,
        {
          passwordHash,
          reset_password_token: undefined,
          reset_token_expires: undefined,
        },
        {
          new: true,
          runValidators: true,
          useFindAndModify: false,
        }
      );
      await res.status(200).json({
        status: 'success',
        data: updatedUser,
      });
    } else {
      res.status(401).json({ error: 'Invalid or expired token' });
    }
  } catch (err) {
    next(err);
  }
};

/*
    @route GET /api/users/unverified
    @desc Get all unverified users
    @access Public
*/

exports.get_unverified_users = async (req, res, next) => {
  try {
    const users = await User.find({ 'usertype.is_verified': false });
    res.status(200).json(users);
  } catch (err) {
    next(err);
  }
};

/* 
    @route GET /api/users/verify/:id
    @desc Verify a user
    @access Private
*/
exports.verify_user = async (req, res, next) => {
  try {
    const user = await User.findByIdAndUpdate(
      req.params.id,
      { 'usertype.is_verified': true },
      {
        new: true,
        runValidators: true,
        useFindAndModify: false,
      }
    );
    res.status(200).json(user);
  } catch (err) {
    next(err);
  }
};

/* 
    @route DELETE /api/users/delete/:id
    @desc Delete a user
    @access Private
*/
exports.delete_user = async (req, res, next) => {
  try {
    const user = req.params.id;
    const hostels = await Hostel.find({ owner: user });
    const reviews = await Review.find({ user: user });

    await Promise.all(
      hostels.map((hostel) => {
        Hostel.findByIdAndDelete(hostel._id);
      })
    );
    await Promise.all(
      reviews.map((review) => {
        Review.findByIdAndDelete(review._id);
      })
    );
    const deletedUser = await User.findByIdAndDelete(user);
    res.status(200).json({
      status: 'success',
      message: 'User deleted successfully',
      deletedUser,
    });
  } catch (err) {
    next(err);
  }
};
