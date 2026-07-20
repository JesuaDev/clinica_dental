const pool = require('../../config/connection_database');
const bycript = require('bcryptjs');
const jwt = require('jsonwebtoken');


exports.login = async (req, res) => {
    try {
        const { email_user, password_user } = req.body;
        if (!email_user || !password_user) return res.status(400).json({ status: 400, message: "Datos Incompletos" });

        const query = `SELECT id_user, email_user, rol, password_user FROM users WHERE email_user = $1`;
        const result = await pool.query(query, [email_user]);

        if (result.rows.length === 0) return res.status(404).json({ status: 404, message: "Usuario/Contraseña no son correctas" });

        const user = result.rows[0];
        const validate = bycript.compareSync(password_user, user.password_user);

        if (!validate) return res.status(401).json({ status: 401, message: "Credenciales Incorrectas" });

        const token = jwt.sign(
            { id: user.id_user, email: user.email_user },
            process.env.TOKEN_SECRET,
            { expiresIn: '12h' }
        )

        const queryUserWithProfile = `SELECT * FROM profile WHERE id_user = $1;`
        const resultProfile = await pool.query(queryUserWithProfile, [user.id_user]); 

        const jsonUserWithProfile = {
            id_user: user.id_user, 
            email_user: user.email_user,
            rol: user.rol,
            profile: resultProfile.rows[0]
        };


        return res.status(200).json({ status: 200, message: "Login Exitoso", data:jsonUserWithProfile,  token: token }); 


    } catch (err) {
        return res.status(500).json({ status: 500, message: `Hubo un error inesperado ${err}` });
    }

}