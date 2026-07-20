const pool = require('../../config/connection_database');
const bycript = require('bcryptjs');


exports.postUser = async (req, res) => {
    try {
        const { email_user, password_user, rol, name_user, last_name_user, picture_profile } = req.body;
        if (!email_user || !password_user || !rol, !name_user, !last_name_user) return res.status(404).json({ status: 404, message: "Datos incompletos" });

        const salt = bycript.genSaltSync(10);
        console.log(salt);
        const passwordHashed = bycript.hashSync(password_user, salt);

        console.log(passwordHashed);

        const queryUser = `INSERT INTO users (email_user, password_user, rol) VALUES ($1, $2, $3) RETURNING *`;
        const resultUser = await pool.query(queryUser, [email_user, passwordHashed, rol]);

        const idUser = resultUser.rows[0].id_user;
        const queryProfile = `INSERT INTO profile (name_user, last_name_user, picture_profile, id_user) VALUES ($1, $2, $3, $4)`;
        const resultProfile = await pool.query(queryProfile, [name_user, last_name_user, picture_profile, idUser]);


        return res.status(201).json({ status: 201, message: "El usuario y perfil se crearon correctamente" });

    } catch (err) {
        return res.status(500).json({ status: 500, message: `Hubo un error inesperado ${err}` });
    }


}

exports.getUsers = async (req, res) => {
    try {
        const query = `SELECT * FROM users u INNER JOIN profile p ON u.id_user = p.id_user `;
        const result = await pool.query(query);

        if (result.rows.length === 0) return res.status(404).json({ status: 404, message: "No existe ningun registro" });

        return res.status(200).json({ status: 200, message: "Registros Consultas Correctamente", data: result.rows }); 

    } catch (err) {
        return res.status(500).json({ status: 500, message: `Hubo un error inesperado ${err}` });
    }


}