const pool = require('../../config/connection_database')

exports.searchPx = async (req, res) => {
    try {
        let search = req.query.search;
 
        const querySearch = `SELECT
            p.id_px,
            p.full_name,
            p.birthdate_px,
            p.sex_px,
            p.phone_px,
            p.direction_px,
            c.fecha_cita 
        FROM px p
        lEFT JOIN (
                SELECT 
                id_px, 
            MAX(fecha_cita) AS fecha_cita
            FROM citas
        GROUP BY id_px
        )  c ON p.id_px = c.id_px 
          WHERE p.id_px::TEXT ILIKE $1 OR 
          p.full_name ILIKE $1 OR 
          p.phone_px ILIKE $1 ORDER BY p.full_name;                       
    `;

        const resultSearch = await pool.query(querySearch, [`%${search}%`]);

        if(resultSearch.rows.length === 0) return res.status(404).json({status:404 , message: "No hay ningún resultado"});

        res.status(200).json({ status: 200, message: "Paciente encontrado", data: search.length === 0 ? [] : resultSearch.rows });

    }
    catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }


}