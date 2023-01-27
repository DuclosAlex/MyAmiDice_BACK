const { characterModel, characteristicModel } = require('../model');
const { createOrUpdate } = require('../model/coreModel');
const coreController = require('./coreController');

const characterController = {

    basicQuery : coreController.createBaseQuery(characterModel, "characters"),

    async getCharacterByIdWithAll( req, res) {

        const result = await characterModel.getCharacterByIdWithAll(req.params.id);

        res.json(result);
    },

    // async createCharacterWithCaracteristics ( req, res) {

    //     const fullCharacters = [];

    //     const createCharacter = await characterModel.createOrUpdate(req.body.characters);

    //     const characteristics = req.body.characteristics;

    //     characteristics.unshift(createCharacter.id);

    //     const createCharacteristics = await characteristicModel.createOrUpdate(characteristics);

    //     fullCharacters.push(createCharacter);
    //     fullCharacters.push(createCharacteristics);

    //     res.json(fullCharacters);
        
    // }
}

module.exports = characterController;