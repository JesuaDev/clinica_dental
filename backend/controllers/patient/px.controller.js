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

        const[patient, count] = await Promise.all([
            pool.query(query,[limit,offset]),
            pool.query(queryCount)
        ]);

        if (patient.rows.length === 0) return res.status(404).json({ status: 404, message: "No hay ningun registro" });
        const total = Number(count.rows[0].total);


        return res.status(200).json({ status: 200, message: "Datos consultados correctamente", data: patient.rows, pagination: {
            page,
            limit,
            total,
            totalPages: Math.ceil(total / limit),
            hasNext: page *limit < total, 
            hasPrevius: page > 1 

        } });
    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }


};

exports.postPatients = async (req, res) => {
    try {
        console.log(req.boy);
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

        console.log(resultPx.rows);

        return res.status(201).json({ status: 201, message: "¡Paciente creado exitosamente!", data: resultPx.rows[0] });
    } catch (error) {
        return res.status(500).json({ status: 500, message: `Hubo un error interno: ${error}` });
    }

}

/* exports.updatePatient = async (req, res) =>{
    const {name_px, last_name_px, sex_px, birthdate_px, phone_px, direction_px, allergys_px, medication_px, diseases_px, medical_record_px} = req.body; 
    const id_px = req.params.id; 


    

} */