const express = require('express');
const { getDiseases, postDisease } = require('../../../controllers/patient/details/diseases.controller');
const router = express.Router(); 


router.get('/diseases', getDiseases);
router.post('/disease', postDisease); 



module.exports = router; 