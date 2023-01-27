const coreModel = require('./coreModel');
const db = require('./dbClient');


const gameModel = {

    ...coreModel,

    async getGameByIdWithAll ( id) {

        let gameWithAll;

        try {

            const sqlQuery = ` SELECT * FROM get_game_by_id_with_all($1)`;

            const values = [];
            values.push(Number(id));
            console.log("values", values[0]);

            const result = await db.query(sqlQuery, values);

            console.log("result", result)

            gameWithAll = result.rows[0];

            console.log("game", gameWithAll);

        } catch(e) {
            console.log("error", e);
        }

        return gameWithAll;
    }

};

module.exports = gameModel;