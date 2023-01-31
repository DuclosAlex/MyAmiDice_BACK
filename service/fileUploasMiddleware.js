// Le fichier fileUploadMiddleware.js
const multer = require('multer');
/*
Cette fonction 'diskStorage' retourne une configuration pour le module multer qui définit où les fichiers envoyés doivent être enregistrés sur le disque.
 La configuration est créée en utilisant la méthode multer.diskStorage.
*/
const diskStorage = (destination) => multer.diskStorage({
/*
L'argument 'destination' fournit un chemin de répertoire de destination pour les fichiers envoyés.
 La méthode 'destination' définit une fonction de rappel qui reçoit les objets req, file, et cb et appelle cb avec le chemin de répertoire 'destination' pour enregistrer le fichier.
*/
destination: (req, file, cb) => cb(null, destination),
/*
La méthode 'filename' définit une fonction de rappel qui reçoit les objets req, file, et cb et appelle cb avec le nom d'origine du fichier envoyé. Cela permet de conserver le nom original du fichier lors de l'enregistrement sur le disque.
*/
filename: (req, file, cb) => cb(null, file.originalname)
});
/*
Cette fonction 'fileUpload' retourne une instance de multer configurée en utilisant la configuration renvoyée par 'diskStorage'.
 Le chemin de destination pour les fichiers envoyés est fourni à 'diskStorage' via l'argument 'destination'.
*/
const fileUpload = (destination) => multer({ storage: diskStorage(destination) });

module.exports = fileUpload;