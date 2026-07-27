const pool = require('../../../config/connection_database');


exports.getReminder = async (req, res) => {
    try {


        const query = `SELECT * FROM reminders`;
        const result = await pool.query(query);
 
        return res.status(201).json({ status: 200, message: "OK", data: result.rows });
    } catch (err) {
        return res.status(500).json({ status: 500, message: `Hubo un error inesperado ${err}` });
    }
}

exports.getRemindersUpComing = async (req, res) => {
    try {
        const query = `SELECT * FROM reminders WHERE date_hour_init >= NOW() ORDER BY date_hour_init LIMIT 10;`;
        const result = await pool.query(query);
 
        return res.status(201).json({ status: 200, message: "OK", data: result.rows });
    } catch (err) {
        return res.status(500).json({ status: 500, message: `Hubo un error inesperado ${err}` });
    }
}