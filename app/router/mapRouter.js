const express = require('express');
const { mapController } = require('../controller');

const router = express.Router();

// router.get('', mapController.basicQuery.getAll);
// router.get('/:id', mapController.basicQuery.getById);
router.delete( '/:id', mapController.basicQuery.deleteById);
router.post('/:id', mapController.basicQuery.createOrUpdate );

module.exports = router;