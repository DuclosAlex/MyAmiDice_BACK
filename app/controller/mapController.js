const { mapModel} = require('../model');
const coreController = require('./coreController');

const mapController = {

    basicQuery : coreController.createBaseQuery(mapModel, "maps")
}

module.exports = mapController;