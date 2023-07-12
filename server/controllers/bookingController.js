const Booking = require('../models/booking');

exports.createBookingCheckout = async (req, res, next) => {
  try {
    // This is only TEMPORARY, because it's UNSECURE: everyone can make bookings without paying
    console.log(req.params);
    const { hostel, user, price } = req.params;

    if (!hostel && !user && !price) return next();

    const booking = await Booking.create({ hostel, user, price });

    res.status(200).json({
      status: 'success',
      data: {
        booking,
      },
    });

    // res.redirect(req.originalUrl.split('?')[0]);
  } catch (error) {
    next(err);
  }
};

exports.getAllBookings = async (req, res, next) => {
  try {
    const bookings = await Booking.find();
    res.status(200).json({
      status: 'success',
      data: {
        bookings,
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.getBooking = async (req, res, next) => {
  try {
    const userId = req.params.id;
    const bookings = await Booking.find({ user: userId });

    res.status(200).json({
      status: 'success',
      data: {
        bookings,
      },
    });
  } catch (err) {
    next(err);
  }
};
