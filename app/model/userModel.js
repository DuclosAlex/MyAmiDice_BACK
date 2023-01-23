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
    }

};

module.exports = userModel;