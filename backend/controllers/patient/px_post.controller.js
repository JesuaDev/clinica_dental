const pool = require('../../config/connection_database')


exports.postPatients = async (req, res) => {
    try {

        const { name_px, last_name_px, sex_px, birthdate_px, phone_px, direction_px, allergys_px, medication_px, diseases_px, medical_record_px } = req.body;
        const full_name = `${name_px} ${last_name_px}`;


        const queryPx = `INSERT INTO px (full_name, birthdate_px, sex_px, phone_px, direction_px) VALUES ($1, $2, $3, $4, $5) RETURNING *;`;
        const resultPx = await pool.query(queryPx, [full_name, birthdate_px, sex_px, phone_px, direction_px]);

        const idPx = resultPx.rows[0].id_px;
        if (resultPx.rows.length > 0 && allergys_px.length > 0) {
            for (var idAllergy of allergys_px) {
                const queryAllergy = `INSERT INTO px_allergy (id_px, id_allergy) VALUES ($1, $2) ;`;
                const resultAllergy = await pool.query(queryAllergy, [idPx, idAllergy]);
            }
        }

        if (resultPx.rows.length > 0 && medication_px.length > 0) {
            for (var idMedication of medication_px) {
                const queryMedication = `INSERT INTO medication_px (id_px, id_medication) VALUES ($1, $2); `;
                const resultMedication = await pool.query(queryMedication, [idPx, idMedication]);
            }
        }

        if (resultPx.rows.length > 0 && diseases_px.length > 0) {
            for (var idDisease of diseases_px) {
                const queryDisease = `INSERT INTO px_diseases (id_px, id_diseases) VALUES ($1, $2);`;
                const resultDisease = await pool.query(queryDisease, [idPx, idDisease]);
            }
        }

        if (resultPx.rows.length > 0 && medical_record_px.length > 0) {
            for (var record of medical_record_px) {
                const queryMedicalRecord = `INSERT INTO dental_record_px (id_px, dental_record, description_record, date_cita, complete) VALUES ($1, $2);`;
                const resultMedicalRecord = await pool.query(queryMedicalRecord, [idPx, record.medical_record, record.description_record, record.date_complete, record.complete]);
            }
        }

 

        return res.status(201).json({ status: 201, message: "¡Paciente creado exitosamente!", data: resultPx.rows[0] });
    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }

}
