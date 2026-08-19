const express = require('express'); 
 
const {verifyFields} = require('../../middleware/verifyFields.middleware'); 
const { getCitas, getCitaUpcoming } = require('../../controllers/appointments/medical_appointment/medical_appointments_get.controller');
const { appoitmentsPost } = require('../../controllers/appointments/medical_appointment/medical_appointments_post.controller');
const router = express.Router(); 


//? GET
router.get('/citas', getCitas); 
router.get('/cita/upcoming', getCitaUpcoming);

//? POST
router.post('/cita', appoitmentsPost); 


module.exports = router; 