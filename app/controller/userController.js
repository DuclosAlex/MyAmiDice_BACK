/**
 * Contrôleur pour les utilisateurs
 * @module userController
 */

const { userModel} = require('../model');
const coreController = require('./coreController');
const db = require('../model/dbClient');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const errorHandler = require('../../service/errorService/errorHandler');

const userController = {

  /**
   * Requête de base pour les utilisateurs
   * @type {BaseQuery}
   */
  basicQuery: coreController.createBaseQuery(userModel, "users"),

  /**
   * Permet de créer un utilisateur
   * @function
   * @async
   * @param {Request} req - Objet Request
   * @param {Response} res - Objet Response
   * @param {Next} next - Permet de passer au middleware suivant
   * @returns {Promise<void>}
   */
  async createUser(req, res, next) {

    try {

      
      if(!req.body) {
        errorHandler._400(req, res, next);
      }
      
      let salt = await bcrypt.genSalt(10);
      req.body.password = await bcrypt.hash(req.body.password, salt);
      
      const user = req.body;
      
      const result = await userModel.insertUser(user);
      
      if(!result) {
        errorHandler._204(req, res, next);
      }
      
      res.json(result);

    } catch(e) {
      errorHandler._500(req, res, next);
    }
  },

  /**
   * Permet de mettre à jour un utilisateur
   * @function
   * @async
   * @param {Request} req - Objet Request
   * @param {Response} res - Objet Response
   * @param {Next} next - Permet de passer au middleware suivant
   * @returns {Promise<void>}
   */
  async updateUser(req, res, next) {

    try {

      if(jwt.verify(req.headers.token, process.env.TOKEN_KEY)) {

        
        if(!req.body) {
          errorHandler._400(req, res, next);
        }
        const user = req.body;
        
        const result = await userModel.updateUser(user);
        
        if(!result) {
          errorHandler._204(req, res, next);
        }
        
        res.json(result);
      } else {
        errorHandler._401(req, res, next);
      }

    } catch(e) {
      errorHandler._500(req, res, next);
    }
  },

  /**
   * Permet de connecter un utilisateur
   * @function
   * @async
   * @param {Request} req - Objet Request
   * @param {Response} res - Objet Response
   * @param {Next} next - Permet de passer au middleware suivant
   * @returns {Promise<void>}
   */
  async logUser(req, res, next) {
    try {

      if(!req.body) {
        errorHandler._400(req, res, next);
      }
      const sqlQuery = `SELECT password FROM "Users" WHERE "Users".email = $1`;
      const values = [req.body.email];

      let password = await db.query(sqlQuery, values);

      if(!password) {
        errorHandler._204(req, res, next);
      }
      password = password.rows[0];

      const compare = await bcrypt.compare(req.body.password, password.password);
      req.body.password = compare;
      const user = req.body;
      const result = await userModel.loginUser(user);
      if (result !== undefined) {
        const token = jwt.sign({ userIsAdmin: result.user.is_admin }, process.env.TOKEN_KEY);
        result.token = token;
        res.json(result);
      } else {
        errorHandler._204(req, res, next);
      }
    } catch (e) {
      errorHandler._500(req, res, next);
    }
  }
};

module.exports = userController;
