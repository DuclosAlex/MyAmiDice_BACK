

const coreController = {

    
    createBaseQuery (model, table) {

        return {

            getAll : async ( req, res) => {
                try {
                    const result = await model.getAll(table);
                    res.json(result);
                } catch(e) {
                    console.log(e.error);
                }
            },

            getById : async ( req, res) => {

                try {

                    const id = req.params.id;
                    const result = await model.getById(table, id);
                    res.json(result);
                    
                } catch(e) {
                    console.log(e.error);
                }
            }
        }
    }

}

module.exports = coreController;