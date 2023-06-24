const multer = require('multer');
const { CreateError } = require('../utils/CreateError');

// Create multer storage configuration
const multerStorage = multer.memoryStorage();

// Multer filter for filtering only images
const multerFilter = (req, file, cb) => {
  // console.log(`Yo multer filter ley gareko ho hai: ${JSON.stringify(file)}`);
  if (file.mimetype.startsWith('image')) {
    cb(null, true);
  } else {
    cb(CreateError('Not an image! Please upload only images.', 400), false);
  }
};

// upload for multer
const upload = multer({
  storage: multerStorage,
  fileFilter: multerFilter,
});

module.exports = upload;
