const { characterModel, characteristicModel } = require('../model');
const { createOrUpdate } = require('../model/coreModel');
const coreController = require('./coreController');

const characterController = {

    basicQuery : coreController.createBaseQuery(characterModel, "characters"),

    async getCharacterByIdWithAll( req, res) {

        const result = await characterModel.getCharacterByIdWithAll(req.params.id);

        res.json(result);
    },

    async createCharacterWithCaracteristics ( req, res) {

        const fullCharacters = [];

        const createCharacter = await characterModel.createOrUpdate(req.body.characters);
        
        const characteristics = req.body.characteristics;

        characteristics.characters_id = createCharacter.id;

        console.log("insertCharacteriscits", characteristics)

        const createCharacteristics = await characteristicModel.createOrUpdate(characteristics);

        console.log("characters", createCharacter);
        console.log("characteristics", createCharacteristics)

        fullCharacters.push(createCharacter);
        fullCharacters.push(createCharacteristics);

        console.log("full", fullCharacters)

        res.json(fullCharacters);
        
    }
}

module.exports = characterController;