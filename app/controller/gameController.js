const { gameModel } = require('../model/');
const coreController = require('./coreController');
const errorHandler = require('../../service/errorService/errorHandler')

const gameController = {

    basicQuery : coreController.createBaseQuery( gameModel, "games"),

    async getGameByIdWithAll( req, res, next) {

        const result = await gameModel.getGameByIdWithAll(req.params.id, req.params.userid);

        if(result) {

            res.json(result);

        } else {

            errorHandler._204(req, res, next);

        }

    }
}

module.exports = gameController;