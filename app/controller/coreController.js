const errorHandler = require('../../service/errorService/errorHandler')


/**
 * @module coreController
 * @description Le module coreController contient des fonctions qui effectuent des opérations CRUD de base sur une table de base de données donnée.
 */
const coreController = {
  /**
   * @function createBaseQuery
   * @param {Object} model - Le modèle de base de données à utiliser pour les opérations de base de données.
   * @param {String} table - Le nom de la table de base de données sur laquelle effectuer les opérations.
   * @returns {Object} Un objet contenant des fonctions pour effectuer des opérations CRUD.
   */
  createBaseQuery(model, table) {
    return {
      /**
       * @function getAll
       * @async
       * @param {Object} req - L'objet de requête entrant.
       * @param {Object} res - L'objet de réponse sortant.
       * @param {Object} next - Pour permettre de passer au middleware suivant
       * @description Récupère tous les enregistrements de la table spécifiée et retourne le résultat sous forme d'objet JSON.
       */
      getAll: async (req, res, next) => {
        try {

          const result = await model.getAll(table);

          if (result) {

            res.json(result);

          }else {

            errorHandler._204(req, res, next);
          }
        } catch (e) {
          
          errorHandler._500(req, res, next);
        }
      },

      /**
       * @function getById
       * @async
       * @param {Object} req - L'objet de requête entrant.
       * @param {Object} res - L'objet de réponse sortant.
       * @param {Object} next - Pour permettre de passer au middleware suivant
       * @description Récupère un seul enregistrement de la table spécifiée en fonction de l'identifiant dans les paramètres de la requête et retourne le résultat sous forme d'objet JSON.
       */
      getById: async (req, res, next) => {
        try {

          if (req.params.id) {

            const id = Number(req.params.id);
            const result = await model.getById(table, id);

            if(result) {

              res.json(result);
            }else {
              errorHandler._204(req, res, next)
            }

          } else {
            errorHandler._400(req, res, next)
          }

        } catch (e) {
          errorHandler._500(req, res, next);
        }
      },

      /**
       * @function deleteById
       * @async
       * @param {Object} req - L'objet de requête entrant.
       * @param {Object} res - L'objet de réponse sortant.
       * @param {Object} next - Permet de passer au middleware suivant
       * @description Supprime un seul enregistrement de la table spécifiée en fonction de l'identifiant dans les paramètres de la requête et retourne le résultat sous forme d'objet JSON.
       */

      deleteById: async (req, res, next) => {
        try {

          if ( req.params.id) {

            const id = req.params.id;
            const result = await model.deleteById(table, id);

            if(result) {

              res.json(result);
            } else {
              errorHandler._204(req, res, next)
            }

          } else {
            errorHandler._400(req, res, next)
          }

        } catch (e) {
          errorHandler._500(req, res, next);
        }
      },

      /**
       * @function createOrUpdate
       * @async
       * @param {Object} req - L'objet requête entrant.
       * @param {Object} res -  L'objet réponse sortant.
       * @param {Object} next - Permet de passer au middleware suivant
       * @description Cette fonction permet de créer ou de mettre à jour un enregistrement unique dans la table spécifiée en fonction des données contenues dans le corps de la requête, puis renvoie le résultat sous forme d'objet JSON.
       */
      createOrUpdate: async (req, res, next) => {
        try {


          let data = req.body;
          const result = await model.createOrUpdate(table, data);

          if(result) {

            res.json(result);
          } else {
            errorHandler._204(req, res, next);
          }
        } catch (e) {
          errorHandler._500(req, res, next);
        }
      },
    };
  },
};

module.exports = coreController;
