
const pool = require('../../../config/connection_database');


exports.postReminder = async (req, res) => {
    try {
        const { title_reminder, description_reminder, date_init, date_limit, id_user } = req.body;

        const queryInsert = `INSERT INTO reminders (title_reminder, description_reminder, date_hour_init, date_hour_limit, id_user) VALUES ($1,$2,$3,$4,$5) RETURNING *`;
        const result = await pool.query(queryInsert, [title_reminder, description_reminder, date_init, date_limit, id_user]);

        const idCalendar = result.rows[0].id_calendar;

        const query = `
            SELECT
                r.id_calendar,
                r.title_reminder,
                r.description_reminder,
                r.date_hour_init,
                r.date_hour_limit,

                json_build_object(
                    'name_user', p.name_user,
                    'picture_profile', p.picture_profile
                ) AS profile

            FROM reminders r

            INNER JOIN users u
            ON u.id_user = r.id_user
            INNER JOIN profile p ON p.id_user = u.id_user

            WHERE r.id_calendar = $1;
         `;

        const resultSelect = await pool.query(query, [idCalendar]);

        return res.status(201).json({ status: 201, message: "Recordatorio Creado Correctamente", data: resultSelect.rows });
    } catch (err) {
        return res.status(500).json({ status: 500, message: `Hubo un error inesperado ${err}` });
    }
}

