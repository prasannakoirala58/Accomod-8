const logger = require('./utils/logger');
const config = require('./utils/config');
const middleware = require('./utils/middleware');
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const cookie_parser = require('cookie-parser');

app = express();

logger.info('connecting to port:', config.PORT);

// Set the strictQuery option
mongoose.set('strictQuery', false); // or true

mongoose
  .connect(config.MONGODB_URI)
  .then(() => {
    logger.info('Database connection successful');
  })
  .catch((error) => {
    logger.error('error connecting to MongoDB: ', error.message);
  });

// app.use(cors({credentials: true, origin: 'https://accomodate.me'}));
app.use(cors({ credentials: true, origin: 'http://localhost:3000' }));
app.use(express.json({ limit: '25mb' }));
app.use(cookie_parser());
app.use(middleware.requestLogger);

/*
    import Routes
*/
const userRouter = require('./routers/userRouter');
const hostelRouter = require('./routers/hostelRouter');
const reviewRouter = require('./routers/reviewRouter');
const analyticsRouter = require('./routers/analyticsRouter');
const bookingRouter = require('./routers/bookingRouter');
const testRouter = require('./routers/testRouter');

app.use('/api/reviews', reviewRouter);
app.use('/api/users', userRouter);
app.use('/api/hostels', hostelRouter);
app.use('/api/analytics', analyticsRouter);
app.use('/api/booking', bookingRouter);
app.use('/api/test', testRouter);

// For dev purposes
// app.use('/', (req, res, next) => {
//   res.status(200).send({
//     status: 'success',
//     data: 'Motu laptop jindabaad!!!',
//   });
// });

app.use((err, req, res, next) => {
  err.status = err.status || 500;
  err.message = err.message || 'Internal Server Error';
  res.status(err.status).json({
    error: err,
    success: false,
    message: err.message,
    stack: err.stack,
  });
});

module.exports = app;
