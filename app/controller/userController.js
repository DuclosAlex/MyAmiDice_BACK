const { userModel} = require('../model');
const coreController = require('./coreController');

const userController = {

    basicQuery : coreController.createBaseQuery( userModel, "users"),

    async createUser ( req, res ) {

        const user = req.body;

        const result = await userModel.insertUser(user);

        res.json(result)
    },

    async updateUser( req, res) {

        const user = req.body;

        const result = await userModel.updateUser(user);

        res.json(result);
    }

}

module.exports = userController;