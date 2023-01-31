const coreController = {
  createBaseQuery(model, table) {
    return {
      getAll: async (req, res) => {
        try {
          const result = await model.getAll(table);
          res.json(result);
        } catch (e) {
          console.log(e.error);
        }
      },

      getById: async (req, res) => {
        try {

          const id = Number(req.params.id);
          const result = await model.getById(table, id);
          res.json(result);
        } catch (e) {
          console.log(e.error);
        }
      },

      deleteById: async (req, res) => {
        try {
          const id = req.params.id;
          const result = await model.deleteById(table, id);
          res.json(result);
        } catch (e) {
          console.log(e.error);
        }
      },

      createOrUpdate: async (req, res) => {
        
        try {

          let data = req.body;

          console.log("data", data);

          const result = await model.createOrUpdate(table, data);

          console.log("result", result)

          res.json(result);
        } catch (e) {
          console.log("error", e);
        }
      },
    };
  },
};

module.exports = coreController;
