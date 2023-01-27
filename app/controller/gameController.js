const { gameModel } = require('../model/');
const coreController = require('./coreController');

const gameController = {

    basicQuery : coreController.createBaseQuery( gameModel, "games"),

    async getGameByIdWithAll( req, res) {

        const result = await gameModel.getGameByIdWithAll(req.params.id);

        res.json(result);
    }
}

module.exports = gameController;