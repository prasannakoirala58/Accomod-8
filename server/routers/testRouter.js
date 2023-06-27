const express = require('express');
const router = express.Router();
const cloudinary = require('cloudinary');

// router.post('/', (req, res) => {
//   console.log(req.body);
//   const data = cloudinary.v2.uploader.upload(
//     'https://upload.wikimedia.org/wikipedia/commons/a/ae/Olympic_flag.jpg',
//     { folder: 'testing', public_id: 'olympic_flag' },
//     function (error, result) {
//       console.log(result);
//     }
//   );

//   console.log(data.secure_url);
//   res.status(200).json({
//     status: 'success',
//     data: req.body,
//   });
// });

router.post('/testUpdate', (req, res) => {
  try {
    const body = req.body;
    const { profile_picture, document } = req.files || {};
    console.log(body.username);
  } catch (error) {
    console.log('Error ayao haai:', error);
  }
});

router.get('/logout', (req, res) => {
  try {
    res.clearCookie('token');
    res.status(200).json({ status: 'success' });
  } catch (err) {
    console.log('Yo logout ko error ho hai:', err);
    // next(err);
  }
});

module.exports = router;
