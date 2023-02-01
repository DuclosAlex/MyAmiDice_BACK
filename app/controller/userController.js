const { userModel} = require('../model');
const coreController = require('./coreController');
const db = require('../model/dbClient');
const bcrypt = require('bcrypt');

const userController = {

    basicQuery : coreController.createBaseQuery( userModel, "users"),

    async createUser ( req, res ) {

        let salt = await bcrypt.genSalt(10)
        req.body.password = await bcrypt.hash(req.body.password, salt)

        const user = req.body;

        const result = await userModel.insertUser(user);

        console.log("resultC", result)

        res.json(result)
    },


    async updateUser( req, res) {

        // let salt = await bcrypt.genSalt(10)
        // req.body.password = await bcrypt.hash(req.body.password, salt) //verifié le nom envoyé par le front

        const user = req.body;

        const result = await userModel.updateUser(user);

        res.json(result);
    },

    async logUser ( req, res) {

        let password = await db.query(`SELECT password FROM "Users" WHERE "Users".email = '${req.body.email} '`);
        password = password.rows[0];
        const compare = await bcrypt.compare(req.body.password, password.password);
        req.body.password = compare;
        const user = req.body;
        const result = await userModel.loginUser(user);
        if (result !== undefined) {
            const token = jwt.sign({ userId: result.user.id}, process.env.TOKEN_KEY);
            result.token = token;
        res.json(result);
        }
    }
}

module.exports = userController;