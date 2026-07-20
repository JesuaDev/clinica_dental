const express = require('express'); 
 
const {verifyFields} = require('../../middleware/verifyFields.middleware'); 
const { getCitas, getCitaUpcoming } = require('../../controllers/patient/citas.controller');
const router = express.Router(); 


router.get('/citas', getCitas); 
router.get('/cita/upcoming', getCitaUpcoming)
 

module.exports = router; 