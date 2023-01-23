const { characterModel } = require('../model');
const coreController = require('./coreController');

const characterController = {

    basicQuery : coreController.createBaseQuery(characterModel, "characters")
}

module.exports = characterController;