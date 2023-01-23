const { gameModel } = require('../model/');
const coreController = require('./coreController');

const gameController = {

    basicQuery : coreController.createBaseQuery( gameModel, "games")
}

module.exports = gameController;