const express = require('express'); 
 
const {verifyFields} = require('../../middleware/verifyFields.middleware'); 
const { getCitas, getCitaUpcoming } = require('../../controllers/appointments/medical_appointment/medical_appointments_get.controller');
const router = express.Router(); 


router.get('/citas', getCitas); 
router.get('/cita/upcoming', getCitaUpcoming)
 

module.exports = router; 