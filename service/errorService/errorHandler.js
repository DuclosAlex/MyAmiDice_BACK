const apiError = require('./apiError');

const errorHandler = {

    
    manage(err, req, res, _) {

        if(err.code) {
            res.status(err.code).json(err.message);
        }
        else {
           res.status(500).json(err.message);
        }
    },

    throw( err, code) {
        throw new apiError(err, code);
    },

    _204 () {
         errorHandler.throw(204, "Désolé, mais nous n'avons pas trouvé de contenu");
    },

    _400 () {
        errorHandler.throw(400, "Désolé, votre demande n'est pas valide ")
    },

    _403() {
        errorHandler.throw(403, "Désolé, vous n'avez pas l'autorisation d'accèder à ce contenu");
    },

    _404() {

        errorHandler.throw(404, "Page non trouvée");
    },

    _500 () {

        errorHandler.throw(500, "Désolé, le système à fait un échec critique")
    },

}

module.exports = errorHandler;