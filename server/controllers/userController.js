const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
// const fs = require('fs');
// const path = require('path');
const User = require('../models/user');
const Hostel = require('../models/hostel');
const Review = require('../models/review');
const crypto = require('crypto');
const sendEmail = require('../utils/mailing');
const cloudinary = require('cloudinary');
const upload = require('../utils/multerConfig');
const { handleCloudinaryUpload, deleteFromCloudinary } = require('../utils/cloudinaryUtils');

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
    @desc create reset password token
    @access Private
*/
const createResetPasswordToken = async () => {
  const resetToken = crypto.randomBytes(20).toString('hex');
  const reset_password_token = crypto.createHash('sha256').update(resetToken).digest('hex');
  const reset_token_expires = Date.now() + 10 * 60 * 1000;
  return { resetToken, reset_password_token, reset_token_expires };
};

/*
    @route GET /api/users
    @desc Get all users
    @access Public
*/
exports.get_users = async (req, res, next) => {
  try {
    const users = await User.find({});
    console.log(users);
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
    console.log(body.username);

    let profileCloudUrl = null;
    let documentCloudUrl = null;

    if (profile_picture) {
      profileCloudUrl = await handleCloudinaryUpload(
        profile_picture[0].buffer,
        'tempPhoto.jpg',
        'avatars',
        `${body.username}_profile}`
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
    @route POST /api/users/logi
    @desc Login a user
    @access Public
*/
exports.login_user = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });

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
          token,
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
exports.update_user = async (req, res, next) => {
  try {
    const body = req.body;
    console.log('body passed', body);
    let profileSecureURL = '';
    let documentSecureURL = '';

    const token = getToken(req);
    const decodedToken = jwt.verify(token, process.env.SECRET);
    if (!token || !decodedToken.id) {
      return res.status(401).json({ error: 'token missing or invalid' });
    }

    const user = await User.findById(decodedToken.id);

    if (body.profile_picture) {
      if (typeof body.profile_picture === 'string') {
        profileSecureURL = body.profile_picture;
      } else {
        const profileCloud = await cloudinary.v2.uploader.upload(body.profile_picture, {
          folder: 'avatars',
          width: 1020,
          crop: 'scale',
        });

        // Delete the existing profile picture from Cloudinary if it exists
        if (user.profile.profile_picture) {
          const publicId = user.profile.profile_picture.split('/avatars/')[1].split('.')[0];
          await cloudinary.v2.uploader.destroy(`avatars/${publicId}`);
        }

        profileSecureURL = profileCloud.secure_url;
      }
    }

    if (body.document) {
      if (typeof body.document === 'string') {
        documentSecureURL = body.document;
      } else {
        const documentCloud = await cloudinary.v2.uploader.upload(body.document, {
          folder: 'documents',
          public_id: `document_${Date.now()}`,
        });

        // Delete the existing document from Cloudinary if it exists
        if (user.profile.document) {
          const publicId = user.profile.document.split('/documents/')[1].split('.')[0];
          await cloudinary.v2.uploader.destroy(`documents/${publicId}`);
        }

        documentSecureURL = documentCloud.secure_url;
      }
    }

    const data = {
      username: body.username,
      email: body.email,
      profile: {
        first_name: body.first_name,
        middle_name: body.middle_name,
        last_name: body.last_name,
        gender: body.gender,
        phone_number: body.phone_number,
        address: body.address,
        profile_picture: profileSecureURL || user.profile.profile_picture,
        document: documentSecureURL || user.profile.document,
      },
    };

    if (user) {
      const updatedUser = await User.findByIdAndUpdate(req.params.id, data, {
        new: true,
        runValidators: true,
        useFindAndModify: false,
      });

      res.status(200).json(updatedUser);
    }
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

    const user = await User.findById(decodedToken.id);
    const correctPassword =
      user === null ? false : await bcrypt.compare(body.old_password, user.passwordHash);

    if (correctPassword) {
      const saltRounds = 10;
      const passwordHash = bcrypt.hashSync(body.new_password, saltRounds);
      const updatedUser = await User.findByIdAndUpdate(
        req.params.id,
        { passwordHash },
        {
          new: true,
          runValidators: true,
          useFindAndModify: false,
        }
      );
      res.status(200).json(updatedUser);
    } else {
      res.status(401).json({ error: 'Incorrect password' });
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
  try {
    const body = req.body;

    const user = await User.findOne({ email: body.email });
    const { resetToken, reset_password_token, reset_token_expires } =
      await createResetPasswordToken();
    const updatedUserResetToken = await User.findByIdAndUpdate(
      user._id,
      { reset_password_token, reset_token_expires },
      {
        new: true,
        runValidators: true,
        useFindAndModify: false,
      }
    );

    /* mail options configured */
    const resetPasswordLink = `${req.protocol}://${req.get(
      'host'
    )}/new_password/${resetToken}`;
    const message = `
            You are receiving this email because you (or someone else) have requested the reset of the password for your account.\n\n
            Please click on the following link, or paste this into your browser to complete the process within one hour of receiving it:\n\n
            ${resetPasswordLink}\n\n
            If you did not request this, please ignore this email and your password will remain unchanged.\n
        `;
    const options = {
      email: body.email,
      subject: 'Reset Password',
      message,
    };

    await sendEmail(options);
    res.status(200).json({
      status: 'success',
      message: 'Token sent to email!',
    });
  } catch (err) {
    next(err);
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

    const reset_password_token = crypto
      .createHash('sha256')
      .update(req.params.token)
      .digest('hex');

    const user = await User.findOne({
      reset_password_token,
      reset_token_expires: { $gt: Date.now() },
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
      await res.status(200).json(updatedUser);
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
