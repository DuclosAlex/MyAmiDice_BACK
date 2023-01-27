const express = require('express');
const { newsController } = require('../controller');

const router = express.Router();

router.get('', newsController.basicQuery.getAll);
router.get('/:id', newsController.basicQuery.getById);
router.delete( '/:id', newsController.basicQuery.deleteById);
router.post('/:id', newsController.basicQuery.createOrUpdate );

module.exports = router;