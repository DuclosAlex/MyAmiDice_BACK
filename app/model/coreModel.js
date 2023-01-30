const db = require('./dbClient')

const coreModel = {

    async getAll (table) {

        let query = `SELECT * FROM get_${table}()`;

        const result = await db.query(query);


        return result.rows;
    },

    async getById( table, id) {

        let values = id;

        let query = ` SELECT * FROM get_${table}_by_id(${values})`;

        const result = await db.query(query);
        return result.rows[0];
    },

    async deleteById ( table, id) {

        let values = id;
        let query = ` SELECT * FROM delete_${table}_by_id(${values})`;

        const result = await db.query(query);
        return result.rows[0];
    },

    async createOrUpdate ( table, data) {

        let values = [];
        let nbDollar = [];
        let counter = 1;

        for( key in data) {

            console.log("key", key);

            values.push(data[key]);
            nbDollar.push(`$${counter}`)
            counter++;
        };

        console.log("values", values);
        console.log("nbDollar", nbDollar);

        let query = ` SELECT * FROM create_or_update_${table}_with_result( ${nbDollar.map( dollar => dollar)} ) `;

        console.log('query', query);

        const result = await db.query(query,  values );

        console.log("result", result)

        return result.rows[0];
    }

}

module.exports = coreModel;