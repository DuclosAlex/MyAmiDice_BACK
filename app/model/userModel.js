const coreModel = require('./coreModel');
const db = require('./dbClient')

const userModel = {

    ...coreModel,

    // async getAll() {

    //     let query = `SELECT * FROM Users`;
    //     const result = await db.query(`SELECT get_user()`);
    //     console.log(result);
    //     return result;

    // }
};

module.exports = userModel;