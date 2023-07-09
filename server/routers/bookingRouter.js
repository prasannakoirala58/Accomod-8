const express = require('express');

const { createBookingCheckout, getAllBookings } = require('../controllers/bookingController');

const router = express.Router();

router.route('/').get(getAllBookings);
router.route('/:id').get(getAllBookings);
router.route('/:hostel/:user/:price').get(createBookingCheckout);

module.exports = router;
