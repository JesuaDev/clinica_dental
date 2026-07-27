
const pool = require('../../../config/connection_database')

exports.getAllergys = async (req, res) => {

    try {
        const query = `SELECT * FROM allergy; `;
        const result = await pool.query(query);

       

        return res.status(200).json({ status: 200, message: "Ok", data: result.rows });


    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }


};

exports.postAllergys = async (req, res) => {
    try {
        const {name_allergy, description_allergy} = req.body; 
   
        const query = `INSERT INTO allergy (name_allergy, description_allergy) VALUES ($1,$2) RETURNING *;`;
        const result = await pool.query(query, [name_allergy, description_allergy]); 

        return res.status(201).json({status:201, message:"Alergia se creo correctamente", data:result.rows[0]});

    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }
}