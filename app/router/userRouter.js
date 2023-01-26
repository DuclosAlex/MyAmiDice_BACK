const express = require('express');
const { userController } = require('../controller');

const router = express.Router();

router.get('', userController.basicQuery.getAll);
router.get('/:id', userController.basicQuery.getById);
router.delete( '/:id', userController.basicQuery.deleteById);
router.post('/create/:id', userController.createUser );
router.post('/update/:id', userController.updateUser);
router.get('/login',userController.logUser );

module.exports = router;