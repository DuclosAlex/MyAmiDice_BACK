const multer = require('multer');

const diskStorage = (destination) => multer.diskStorage({
  destination: (req, file, cb) => cb(null, destination),
  filename: (req, file, cb) => cb(null, file.originalname)
});

const fileUpload = (destination) => multer({ storage: diskStorage(destination) });

module.exports = fileUpload;
