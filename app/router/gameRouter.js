const express = require('express');
const { gameController } = require('../controller');

const router = express.Router();

router.get('/getall', gameController.basicQuery.getAll);
router.get('/:id', gameController.getGameByIdWithAll);
router.delete( '/:id', gameController.basicQuery.deleteById);
router.post('', gameController.basicQuery.createOrUpdate );

module.exports = router;