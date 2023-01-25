const { characterModel } = require('../model');
const coreController = require('./coreController');

const characterController = {

    basicQuery : coreController.createBaseQuery(characterModel, "characters"),

    async getCharacterByIdWithAll( req, res) {

        const result = await characterModel.getCharacterByIdWithAll(req.params.id);

        res.json(result);
    }
}

module.exports = characterController;