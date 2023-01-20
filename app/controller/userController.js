const User = require('../model/userModel');
const coreController = require('./coreController');

const userController = {

    basicQuery : coreController.createBaseQuery(User, "users")
}

module.exports = userController;