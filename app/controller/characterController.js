const { characterModel, characteristicModel } = require('../model');
const coreController = require('./coreController');
const jwt = require('jsonwebtoken');
const errorHandler = require('../../service/errorService/errorHandler');

const characterController = {

    basicQuery : coreController.createBaseQuery(characterModel, "characters"),
    
    async getCharacterByIdWithAll( req, res, next) {

        try {

            
            if(jwt.verify(req.headers.token, process.env.TOKEN_KEY)) {

                if(!req.params.id || req.params.id !== Number) {

                    errorHandler._400(req, res, next);
                }                    
                    const result = await characterModel.getCharacterByIdWithAll(req.params.id);

                    if(!result) {
                        errorHandler._204(req, res, next);
                    }
                    
                    res.json(result);  
            } else {
                errorHandler._401(req, res, next);
            }
        }catch(e) {
            errorHandler._500(req, res, next);
        }        
    },

    async createCharacterWithCaracteristics ( req, res, next) {

        try {
     
            const fullCharacters = [];
            
            let character;

            
            if(jwt.verify(req.headers.token, process.env.TOKEN_KEY)) {
                
                if(!req.body) {
                    errorHandler._400(req, res, next);
                }
                    
                if (req.file) {         //si j'ai un fichier alors je recup le req.body[0]
                    character = req.body[0]; //je le nomme character
                    character.avatar = req.file.path;  //je donne a la clef avatar le chemin du fichier enregister
                } else {    //si pas de fichier je ne fais rien et te laisse executer ton code
                    console.error("Aucun fichier n'a été trouvé dans la requête");
                    character = req.body[0]
                }
                
                const createCharacter = await characterModel.createOrUpdate("characters", character); //et ici character a la place du req.body[0]

                if(!createCharacter) {
                    errorHandler._204(req, res, next);
                }       
                const characteristics = req.body[1];
                
                characteristics.characters_id = createCharacter.id;
                
                const createCharacteristics = await characteristicModel.createOrUpdate("characteristics", characteristics);

                if(!createCharacteristics) {
                    errorHandler._204(req, res, next);
                }    
                
                fullCharacters.push(createCharacter);
                fullCharacters.push(createCharacteristics);
                
                res.json(fullCharacters);

            } else {
                errorHandler._401(req, res, next);
            }
        } catch(e) {
            errorHandler._500(req, res, next)
        }
    },
        
    async updateCharacter (req, res) {

        let character;

        try {

            
            if(jwt.verify(req.headers.token, process.env.TOKEN_KEY)) {

                if(!req.body) {
                    errorHandler._400(req, res, next);
                }
                
                if (req.file) {         //si j'ai un fichier alors je recup le req.body[0]
                    character = req.body; //je le nomme character
                    character.url = req.file.path;  //je donne a la clef avatar le chemin du fichier enregister
                } else {    //si pas de fichier je ne fais rien et te laisse executer ton code
                    console.error("Aucun fichier n'a été trouvé dans la requête");
                    character = req.body
                }
                
                const updateCharacter = await characterModel.createOrUpdate("characters", character);

                if(!updateCharacter) {
                    errorHandler._204(req, res, next);
                }
                
                res.json(updateCharacter);
            } else {
                errorHandler._401(req, res, next);
            }
        } catch(e) {
            console.log(e);
            errorHandler._500(req, res, next);
        }
    }
}

module.exports = characterController;