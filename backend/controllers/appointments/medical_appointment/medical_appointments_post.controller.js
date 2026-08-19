
const pool = require('../../../config/connection_database');

exports.appoitmentsPost = async (req, res) => {
    try {
        const { id_px, id_dentist, reason_appoitment, fecha_appoitment, hour_date, price, diagnosis, observation } = req.body;
        const status = "pendiente";

        const queryAppoitment = `
            INSERT INTO citas 
            (id_px, reason_date, fecha_cita, hour_cita, price_cita, diagnosis, observation, id_dentist, status) 
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) 
            RETURNING id_cita, reason_date, fecha_cita, hour_cita, price_cita, id_px, status; 
        `;

        const queryGetPx = `
            SELECT 
            full_name,
            phone_px, 
            birthdate_px,
            age
            FROM px WHERE id_px = $1
        `

        const [medicalAppoitment, px] = await Promise.all([
            pool.query(queryAppoitment, [id_px, reason_appoitment, fecha_appoitment, hour_date, price, diagnosis, observation, id_dentist, status]),
            pool.query(queryGetPx, [id_px])
        ])


        const citaData = medicalAppoitment.rows.map((row) => ({
            id_cita: row.id_cita,
            reason_date: row.reason_date,
            fecha_cita: row.fecha_cita,
            hour_cita: row.hour_cita,
            price_cita: row.price_cita,
            status: row.status,
            px: {
                id_px: px.rows[0].id_px,
                full_name: px.rows[0].full_name,
                phone_px: px.rows[0].phone_px,
                sex_px: px.rows[0].sex_px,
                birthdate_px: px.rows[0].birthdate_px,
                age: px.rows[0].age
            }
        }));

        return res.status(201).json({ status: 201, message: "La cita se creo exitosamente", data: citaData[0] });

    } catch {

        return res.status(500).json({ status: 500, message: `Hubo un error, intentalo más tarde. ${error}` })
    }
}