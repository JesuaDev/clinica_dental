const express = require('express');
const router = express.Router(); 
const {getMedications, postMedication } = require('../../controllers/patient/medications.controller');

router.get('/medications', getMedications); 
 
router.post('/medication' , postMedication); 

module.exports = router; 