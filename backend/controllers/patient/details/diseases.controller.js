const pool = require('../../../config/connection_database')

exports.getDiseases = async (req, res)=>{
  try {
        const query = `SELECT * FROM diseases; `;
        const result = await pool.query(query);

        return res.status(200).json({ status: 200, message: "Ok", data: result.rows });
    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno`, details: error });
    }

}


exports.postDisease = async (req, res) => {
    try {
        const {name_diseases,  description_diseases, observation_diseases} = req.body; 
   
        const query = `INSERT INTO diseases (name_diseases, description_diseases, observation_diseases) VALUES ($1,$2, $3) RETURNING *;`;
        const result = await pool.query(query, [name_diseases,  description_diseases, observation_diseases]); 

        return res.status(201).json({status:201, message:"Enfermedad se creo correctamente", data:result.rows[0]});

    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }
}