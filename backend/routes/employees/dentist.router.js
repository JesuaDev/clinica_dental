const express = require('express'); 
const { dentistSearch } = require('../../controllers/employees/dentist/dentist_search.controller');
const router = express.Router(); 



router.get('/dentist/search', dentistSearch); 


module.exports = router; 