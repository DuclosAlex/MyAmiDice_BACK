const { gameModel } = require('../model/');
const coreController = require('./coreController');
const errorHandler = require('../../service/errorService/errorHandler')

const gameController = {

    basicQuery : coreController.createBaseQuery( gameModel, "games"),

    async getGameByIdWithAll( req, res, next) {

        try {

            
            const result = await gameModel.getGameByIdWithAll(req.params.id, req.params.userid);
            
            if(result) {
                
                res.json(result);
                
            } else {
                
                errorHandler._204(req, res, next);
                
            }
        } catch(e) {
            
            errorHandler._500(res, res, next);
        }

    }
}

module.exports = gameController;