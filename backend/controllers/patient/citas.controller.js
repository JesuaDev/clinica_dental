const pool = require('../../config/connection_database')

exports.getCitas = async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        //const offset = req.query.offset; 
        const limit = parseInt(req.query.limit) || 15;
        const offset = (page - 1) * limit;

        const query = `SELECT
            c.id_cita,
            c.id_px,
            c.reason_date,
            c.fecha_cita,
            c.hour_cita,
            c.price_cita,
            c.diagnosis,
            c.observation,
            c.id_dentist,
            c.status,
            p.full_name,
            p.phone_px,
            p.sex_px,
            p.birthdate_px
        FROM citas c INNER JOIN px p ON c.id_px = p.id_px
        ORDER BY c.id_cita DESC
        LIMIT $1 OFFSET $2;`;


        const queryCount = `

            SELECT COUNT(*) AS total FROM citas; 
        
        `;

        const [citas, count] = await Promise.all([
            pool.query(query, [limit, offset]),
            pool.query(queryCount)
        ]);

        if (citas.rows.length === 0) return res.status(404).json({ status: 404, message: "No hay ningun registro" });
        const total = Number(count.rows[0].total);

        const citasData = citas.rows.map((row) => ({

            id_cita: row.id_cita,

            reason_date: row.reason_date,
            fecha_cita: row.fecha_cita,
            hour_cita: row.hour_cita,
            price_cita: row.price_cita,
            diagnosis: row.diagnosis,
            observation: row.observation,
            status: row.status, 
            px: {
                id_px: row.id_px,
                full_name: row.full_name,
                phone_px: row.phone_px,
                sex_px: row.sex_px,
                birthdate_px: row.birthdate_px,
            }
        }));

        return res.status(200).json({
            status: 200, message: "Datos consultados correctamente", data: citasData, pagination: {
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


exports.getCitaUpcoming = async (req, res) => {
    try {

        const query = `
SELECT
    c.id_cita,
    c.id_px,
    c.reason_date,
    c.fecha_cita,
    c.hour_cita,
    c.id_dentist,
    c.status
    p.full_name
FROM citas c
INNER JOIN px p ON c.id_px = p.id_px
WHERE
    (c.fecha_cita > CURRENT_DATE)
    OR (
        c.fecha_cita = CURRENT_DATE
        AND c.hour_cita >= CURRENT_TIME
    )
ORDER BY
    c.fecha_cita ASC,
    c.hour_cita ASC
LIMIT 1;
`;

        const cita = await pool.query(query);

        const citaData = citas.rows.map((row) => ({

            id_cita: row.id_cita,
            reason_date: row.reason_date,
            fecha_cita: row.fecha_cita,
            hour_cita: row.hour_cita,
            status: row.status, 
            px: {
                id_px: row.id_px,
                full_name: row.full_name,
            }
        }));

        return res.status(200).json({
            status: 200, message: "Próxima cita consultada correctamente", data: citaData
        });
    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }


};

/*id_cita,
            id_px,
            reason_date,
            fecha_cita,
            hour_cita,
            price_cita,
            diagnosis,
            observation,*/