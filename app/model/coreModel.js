const db = require('./dbClient')

const coreModel = {

    async getAll (table) {

        let query = `SELECT get_${table}()`;

        const result = await db.query(query);
        return result.rows;
    },

    async getById( table, id) {

        let values = id;

        let query = ` SELECT get_${table}_by_id(${values})`;

        const result = await db.query(query);
        return result.rows[0];
    },

    async deleteById ( table, id) {

        let values = id;
        let query = ` SELECT delete_${table}_by_id(${values})`;

        const result = await db.query(query);
        return result.rows[0];
    },

    async createOrUpdate ( table, data) {

        console.log("dataModel", data);

        let array = [];

        for( key in data) {

            console.log("key", key);

            array.push(data[key]);
        };
        

        console.log("array", array)

        let query = ` SELECT create_or_update_${table}_with_result( ${ array.map( value => ` '${value}' `)})`;

        console.log("query", query)

        const result = await db.query(query);

        return result.rows[0];
    }


    

}

module.exports = coreModel;