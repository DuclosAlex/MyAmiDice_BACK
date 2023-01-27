const express = require('express');
const { characteristicController } = require('../controller');

const router = express.Router();

router.get('', characteristicController.basicQuery.getAll);
router.get('/:id', characteristicController.basicQuery.getById);
router.delete( '/:id', characteristicController.basicQuery.deleteById);
router.post('', characteristicController.basicQuery.createOrUpdate );

module.exports = router;