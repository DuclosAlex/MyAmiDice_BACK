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

        console.log('body', req.body);

        const createCharacter = await characterModel.createOrUpdate(req.body[0]);

        console.log('characterbefore', createCharacter)
        
        const characteristics = req.body[1];

        console.log("charac without char_id", characteristics)

        characteristics.characters_id = createCharacter.id;

        console.log('characteristicsBefore', characteristics)

        console.log("insertCharacteriscits", characteristics)

        const createCharacteristics = await characteristicModel.createOrUpdate(characteristics);

        console.log("characters", createCharacter);
        console.log("characteristics", createCharacteristics)

        fullCharacters.push(createCharacter);

        console.log("fullCharac onlu char", fullCharacters)
        fullCharacters.push(createCharacteristics);

        console.log("full", fullCharacters)

        res.json(fullCharacters);
        
    }
}

module.exports = characterController;