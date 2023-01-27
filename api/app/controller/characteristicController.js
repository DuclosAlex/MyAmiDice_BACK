const { characteristicModel } = require('../model');
const coreController = require('./coreController');

const characteristicController = {

    basicQuery : coreController.createBaseQuery(characteristicModel, "characteristics"),

    async updateCharacteristic( req, res) {

        const characteristics = req.body;

        const result = await characteristicModel.updateCharacteristic(characteristics);

        res.json(result);
    }
}

module.exports = characteristicController;