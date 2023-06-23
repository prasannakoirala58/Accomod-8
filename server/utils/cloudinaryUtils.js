const fs = require('fs');
const path = require('path');
const cloudinary = require('cloudinary');

// Helper function to create temporary file on disk (for registering user)
const createTempFile = (buffer, fileName) => {
  const tempFilePath = path.join(__dirname, fileName);
  fs.writeFileSync(tempFilePath, buffer);
  return tempFilePath;
};

// Helper function to upload file to Cloudinary (for registering user)
const uploadToCloudinary = async (filePath, folder, publicId) => {
  const uploadResult = await cloudinary.uploader.upload(filePath, {
    folder,
    public_id: publicId,
  });
  return uploadResult.secure_url;
};

// Helper function to handle file upload and cleanup (for registering user)
const handleCloudinaryUpload = async (fileBuffer, fileName, folder, publicId) => {
  const tempFilePath = createTempFile(fileBuffer, fileName);
  const uploadedFileUrl = await uploadToCloudinary(tempFilePath, folder, publicId);
  fs.unlink(tempFilePath, (err) => {
    if (err) {
      console.error(`Error deleting temporary file ${tempFilePath}:`, err);
    }
  });
  return uploadedFileUrl;
};

// For Deleting file from Cloudinary

// Helper function to extract public_id from Cloudinary file URL
const getPublicIdFromUrl = (fileUrl) => {
  const publicId = fileUrl.substring(fileUrl.lastIndexOf('/') + 1, fileUrl.lastIndexOf('.'));
  return publicId;
};

// Helper function to delete file from Cloudinary
const deleteFromCloudinary = async (fileUrl) => {
  const publicId = getPublicIdFromUrl(fileUrl);
  const deletionResult = await cloudinary.uploader.destroy(publicId);
  return deletionResult.result === 'ok';
};

module.exports = {
  handleCloudinaryUpload,
  deleteFromCloudinary,
};
