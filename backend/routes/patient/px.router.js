const express = require('express'); 
const { getPatients, postPatients } = require('../../controllers/patient/px.controller');
const {verifyFields} = require('../../middleware/verifyFields.middleware'); 
const router = express.Router(); 


router.get('/patients', getPatients); 
router.post('/patient', verifyFields(["name_px"]) , postPatients);



module.exports = router; 