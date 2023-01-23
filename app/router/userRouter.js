const express = require('express');
const { userController } = require('../controller');

const router = express.Router();

router.get('', userController.basicQuery.getAll);
router.get('/:id', userController.basicQuery.getById);
router.delete( '/:id', userController.basicQuery.deleteById);
router.post('/:id', userController.basicQuery.createOrUpdate );

module.exports = router;