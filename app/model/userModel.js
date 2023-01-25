const coreModel = require('./coreModel');
const db = require('./dbClient');

const userModel = {

    ...coreModel,

    async insertUser(user) {

        let createUser;

        try {

            const sqlQuery = ` SELECT * FROM create_users_with_result($1, $2, $3) `;

            const values = [ user.pseudo, user.email, user.password];
            const result = await db.query(sqlQuery, values);
            createUser = result.rows[0];
        } catch(e) {
            console.log(e);
        }

        return createUser;
    },

    async updateUser(user) {

        let updateUser;
        let values = [];
        let nbDollar = [];
        let counter = 1;

        for( key in user) {

            console.log("key", key);

            values.push(user[key]);
            nbDollar.push(`$${counter}`)
            counter++;
        };
        values[0] = Number(values[0]);

        try {

            const sqlQuery = ` SELECT * FROM update_users_with_result(  ${nbDollar.map( dollar => dollar)} )`;

            const result = await db.query(sqlQuery, values);

            updateUser = result.rows[0];
 
        } catch(e) {
            console.log(e);
        }

        return updateUser;
    }

};

module.exports = userModel;