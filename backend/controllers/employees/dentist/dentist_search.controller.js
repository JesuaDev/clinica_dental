
const pool = require('../../../config/connection_database');


exports.dentistSearch = async (req, res) => {

   try{
       const search = req.query.search;
  
    const querySearch = `
        SELECT 
        d.id_dentist, 
        d.name_dentist,
        d.last_name, 
        d.available, 
        d.phone_dentist,
        d.age,
        d.email, 
        d.picture_dentist
        FROM dentist d WHERE d.id_dentist::TEXT ILIKE $1 
        OR d.name_dentist ILIKE $1 
        OR d.last_name ILIKE $1 
        OR d.phone_dentist ILIKE $1 ORDER BY d.name_dentist;            
    `;

    const resultSearch = await pool.query(querySearch, [`%${search}%`]);

    if (resultSearch.rows.length === 0) return res.status(404).json({ status: 404, message: "No hay ningún resultado" });

    console.log(resultSearch.rows);

    res.status(200).json({ status: 200, message: "Dentista encontrado", data: search.length === 0 ? [] : resultSearch.rows });

   }
 catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }


}