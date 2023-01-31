// Dans le fichier characterRouter.js
const express = require('express');
const { characterController } = require('../controller');
const fileUpload = require('../services/fileUploadMiddleware')('public/characters/');

const router = express.Router();

router.get('/getall', characterController.basicQuery.getAll);
router.get('/:id', characterController.getCharacterByIdWithAll);
router.delete( '/:id', characterController.basicQuery.deleteById);
router.post('/create', fileUpload.single('file'), characterController.createCharacterWithCaracteristics );

module.exports = router;