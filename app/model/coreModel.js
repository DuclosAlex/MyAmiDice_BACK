const db = require('./dbClient')

const coreModel = {

    async getAll (table) {

        let query = `SELECT get_${table}()`;

        const result = await db.query(query);
        return result.rows;
    },

    async getById( table, id) {

        let values = id;
        console.log(values)
        let query = ` SELECT get_${table}_by_id(${values})`;
        console.log(query);

        const result = await db.query(query);
        return result.rows[0];
    }
    

}

module.exports = coreModel;