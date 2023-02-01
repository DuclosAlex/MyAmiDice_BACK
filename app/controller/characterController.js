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
        /*
        if (req.file) {         //si j'ai un fichier alors je recup le req.body[0]
            let character = req.body[0]; //je le nomme character
            character.avatar = req.file.path;  //je donne a la clef avatar le chemin du fichier enregister
        } else {    si pas de fichier je ne fais rien et te laisse executer ton code
        console.error("Aucun fichier n'a été trouvé dans la requête");
            au pire je récupére le req.body sans rien changer et tu utilise toujours character dans create du dessous
            let character = req.body[0]
        }
        */
        console.log('character', req.body[0])

        const createCharacter = await characterModel.createOrUpdate("characters", req.body[0]); //et ici character a la place du req.body[0]

        console.log('characterbefore', createCharacter)
        
        const characteristics = req.body[1];

        console.log("charac without char_id", characteristics)

        characteristics.characters_id = createCharacter.id;

        console.log('characteristicsBefore', characteristics);

        console.log("insertCharacteriscits", characteristics);

        const createCharacteristics = await characteristicModel.createOrUpdate("characteristics", characteristics);

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