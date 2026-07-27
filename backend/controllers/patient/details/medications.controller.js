const pool = require('../../../config/connection_database')

exports.getMedications = async (req, res)=>{
  try {
        const query = `SELECT * FROM medications; `;
        const result = await pool.query(query);

        //if (result.rows.length === 0) return res.status(404).json({ status: 404, message: "No existen registros de medicaciones" });

        return res.status(200).json({ status: 200, message: "Ok", data: result.rows });


    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno`, details: error });
    }

}

exports.postMedication = async (req, res) => {
    try {
        const {name_medication,  dose_medication} = req.body; 
   
        const query = `INSERT INTO medications (name_medication, dose_medication) VALUES ($1,$2) RETURNING *;`;
        const result = await pool.query(query, [name_medication,  dose_medication]); 

        return res.status(201).json({status:201, message:"Medicación se creo correctamente", data:result.rows[0]});

    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }
}