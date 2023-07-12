const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  hostel: {
    type: mongoose.Schema.ObjectId,
    ref: 'Hostel',
    required: [true, 'Booking must belong to a hostel!'],
  },
  user: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
    required: [true, 'Booking must belong to a user!'],
  },
  price: {
    type: Number,
    required: [true, 'Booking must have a price!'],
  },
  createdAt: {
    type: Date,
    default: Date.now(),
  },
  paid: {
    type: Boolean,
    default: true,
  },
});

// This query middleware is used to populate the tour and user fields in the
// booking document whenever there is a query for a booking document
bookingSchema.pre(/^find/, function (next) {
  this.populate('user').populate({
    path: 'hostel',
    select: 'name',
  });
  next();
});

const Booking = mongoose.model('Booking', bookingSchema);

module.exports = Booking;

// module.exports = mongoose.model('Booking', bookingSchema);
