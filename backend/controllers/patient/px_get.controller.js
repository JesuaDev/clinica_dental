const pool = require('../../config/connection_database')

exports.getPatients = async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        //const offset = req.query.offset; 
        const limit = parseInt(req.query.limit) || 20;
        const offset = (page - 1) * limit;

        const query = `SELECT
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
        ORDER BY p.id_px DESC
        LIMIT $1 OFFSET $2;`;


        const queryCount = `

            SELECT COUNT(*) AS total FROM px; 
        
        `;

        const [patient, count] = await Promise.all([
            pool.query(query, [limit, offset]),
            pool.query(queryCount)
        ]);

        if (patient.rows.length === 0) return res.status(404).json({ status: 404, message: "No hay ningun registro" });
        const total = Number(count.rows[0].total);


        return res.status(200).json({
            status: 200, message: "Datos consultados correctamente", data: patient.rows, pagination: {
                page,
                limit,
                total,
                totalPages: Math.ceil(total / limit),
                hasNext: page * limit < total,
                hasPrevius: page > 1

            }
        });
    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }


};

