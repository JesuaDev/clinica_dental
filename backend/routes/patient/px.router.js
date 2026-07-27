const express = require('express'); 

const {verifyFields} = require('../../middleware/verifyFields.middleware'); 
const {getPatients} = require('../../controllers/patient/px_get.controller'); 
const {searchPx} = require('../../controllers/patient/px_search.controller'); 
const {postPatients} = require('../../controllers/patient/px_post.controller'); 
const router = express.Router(); 

router.get('/patients',getPatients ); 
router.get('/patient/search',searchPx )
router.post('/patient', verifyFields(["name_px"]) , postPatients);

module.exports = router; 