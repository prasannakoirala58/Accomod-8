const crypto = require('crypto');
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    username: {
      type: String,
      required: [true, 'Please provide a username'],
      unique: true,
    },
    email: {
      type: String,
      required: [true, 'Please provide an email'],
      unique: true,
    },
    passwordHash: {
      type: String,
      required: [true, 'Please provide a password'],
      select: false,
    },
    usertype: {
      typeof_user: {
        type: String,
        default: 'user',
        enum: ['user', 'owner','admin'],
        // required: true,
      },
      is_verified: {
        type: Boolean,
        default: false,
      },
    },
    profile: {
      first_name: {
        type: String,
        required: [true, 'Please provide a first name'],
      },
      middle_name: {
        type: String,
        required: false,
      },
      last_name: {
        type: String,
        required: [true, 'Please provide a last name'],
      },
      gender: {
        type: String,
        required: [true],
      },
      phone_number: {
        type: String,
        required: false,
      },
      address: {
        type: String,
        required: false,
      },
      profile_picture: {
        type: String,
        // we are not using this field for now
        required: false,
      },
      document: {
        type: String,
        required: false,
      },
    },
    reviews: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Review',
        required: false,
      },
    ],
    hostel_listings: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Hostel',
        required: false,
      },
    ],
    // reset_password_token: {
    //   type: String,
    //   required: false,
    // },
    // reset_token_expires: {
    //   type: Date,
    //   required: false,
    // },
    passwordResetToken: String,
    passwordResetExpires: Date,
  },
  { timestamps: true }
);

userSchema.set('toJSON', {
  transform: (document, returnedObject) => {
    returnedObject.id = returnedObject._id.toString();
    delete returnedObject._id;
    delete returnedObject.__v;
  },
});

/* 
    @desc create reset password token
    @access Private
*/
userSchema.methods.createPasswordResetToken = function () {
  // Creates a random string that will be used as a token to reset the password
  const resetToken = crypto.randomBytes(32).toString('hex');

  // Save the reset token to the user model's passwordResetToken schema field
  this.passwordResetToken = crypto.createHash('sha256').update(resetToken).digest('hex');

  // Then save the expiry date of the token to the passwrordResetExpires schema field
  this.passwordResetExpires = Date.now() + 10 * 60 * 1000; // 10 minutes

  // return the unencrypted reset token via email to the user
  // so that they can use it to reset their password but save the encrypted version to the database
  return resetToken;
};

module.exports = mongoose.model('User', userSchema);
