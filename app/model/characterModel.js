const db = require('./dbClient');
const coreModel = require('./coreModel');

const characterModel = {

    ...coreModel,

    async getCharacterByIdWithAll ( id) {

        let characterWithAll;

        try {

            const sqlQuery = ` SELECT * FROM get_character_by_id_with_all($1)`;

            const values = [];
            values.push(Number(id));
            console.log("values", values[0]);

            const result = await db.query(sqlQuery, values);

            console.log("result", result)

            characterWithAll = result.rows[0].character;

            console.log("character", characterWithAll);

        } catch(e) {
            console.log("error", e);
        }

        return characterWithAll;
    }

};

module.exports = characterModel;