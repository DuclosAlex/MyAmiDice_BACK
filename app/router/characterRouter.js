const express = require('express');
const { characterController } = require('../controller');

const router = express.Router();

router.get('/getall', characterController.basicQuery.getAll);
router.get('/:id', characterController.getCharacterByIdWithAll);
router.delete( '/:id', characterController.basicQuery.deleteById);
router.post('/create', characterController.createCharacterWithCaracteristics);

module.exports = router;