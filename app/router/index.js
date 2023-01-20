const express = require('express');

const userController = require('../controller/userController');

const router = express.Router();

router.get('/users', userController.basicQuery.getAll);
router.get('/users/:id', userController.basicQuery.getById);
router.delete( '/users/:id', userController.basicQuery.deleteById);
router.post('/users/:id', userController.basicQuery.createOrUpdate );

module.exports = router;