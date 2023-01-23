const { userModel} = require('../model');
const coreController = require('./coreController');

const userController = {

    basicQuery : coreController.createBaseQuery( userModel, "users")
}

module.exports = userController;