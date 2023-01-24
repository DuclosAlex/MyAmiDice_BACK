const express = require('express');
const { characterController } = require('../controller');

const router = express.Router();

router.get('', characterController.basicQuery.getAll);
router.get('/:id', characterController.getCharacterByIdWithAll);
router.delete( '/:id', characterController.basicQuery.deleteById);
router.post('/:id', characterController.basicQuery.createOrUpdate );

module.exports = router;