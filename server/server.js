const app = require('./app');
const http = require('http');
const config = require('./utils/config');
const logger = require('./utils/logger');
const cloudinary = require('cloudinary');

// Cloudinary configuration
cloudinary.v2.config({
  cloud_name: config.CLOUDINARY_NAME,
  api_key: config.CLOUDINARY_API_KEY,
  api_secret: config.CLOUDINARY_API_SECRET,
});

const server = http.createServer(app);

server.listen(config.PORT, () => {
  logger.info(`Server running on port ${config.PORT}`);
});
