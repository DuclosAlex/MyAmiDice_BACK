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
   * @param {Object} next - Permet de passer au middleware suivant
   * @returns {Promise<void>}
   */
  async createUser(req, res, next) {

    try {
      // On génère le "sel" pour que bcrypt hash le mot de passe
      let salt = await bcrypt.genSalt(10);
      // Hashage du mot de passe
      req.body.password = await bcrypt.hash(req.body.password, salt);
      
      const user = req.body;
      
      const result = await userModel.insertUser(user);
      
      res.json(result);

    } catch(e) {
      next(e);
    }
  },

  /**
   * Permet de mettre à jour un utilisateur
   * @function
   * @async
   * @param {Request} req - Objet Request
   * @param {Response} res - Objet Response
   * @param {Object} next - Permet de passer au middleware suivant
   * @returns {Promise<void>}
   */
  async updateUser(req, res, next) {

    try {

      if(jwt.verify(req.headers.token, process.env.TOKEN_KEY)) {

        const user = req.body;
        
        const result = await userModel.updateUser(user);
        
        res.json(result);
      }

    } catch(e) {
      next(e);
    }
  },

  /**
   * Permet de connecter un utilisateur
   * @function
   * @async
   * @param {Request} req - Objet Request
   * @param {Response} res - Objet Response
   * @param {Object} next - Permet de passer au middleware suivant
   * @returns {Promise<void>}
   */
  async logUser(req, res, next) {
    try {

      // Récupération du mot de passe hashé grâce à l'email
      const sqlQuery = `SELECT * FROM get_password($1)`;
      const values = [req.body.email];

      let password = await db.query(sqlQuery, values);
      // On teste si un mot de passe a été trouvé
      if( !password ) {
        res.status(401).json({
          "errMessage" : " Désolé, un ou plusieurs de vos identifiants sont faux"
        }) 
      }
      password = password.rows[0];

      // Utilisation de bcrypt pour vérifier si le mot de passe envoyé par l'utilisateur correspondnt à celui 
      // en base de données / le résultat sera true ou false
      const compare = await bcrypt.compare(req.body.password, password.password);
      req.body.password = compare;
      if(compare === false) {
        res.status(401).json({
          "errMessage" : " Désolé, un ou plusieurs de vos identifiants sont faux"

        }) 
      }
      const user = req.body;
      // On récupère les infos du user
      const result = await userModel.loginUser(user);
      // Si l'utilisateur est trouvé, on lui assigne un token pour l'authentifier avant de renvoyer le résultat
      if (result !== undefined) {
        const token = jwt.sign({ userIsAdmin: result.user.is_admin }, process.env.TOKEN_KEY);
        result.token = token;
        res.json(result);
      }
    } catch (e) {
      next(e)
    }
  }
};

module.exports = userController;
