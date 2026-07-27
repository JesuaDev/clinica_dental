const express = require('express');
const router = express.Router();

const { getAllergys, postAllergys } = require('../../../controllers/patient/details/allergys.controller');
const { verifyFields } = require('../../../middleware/verifyFields.middleware');

router.get("/allergys", getAllergys);
 router.post("/allergy", verifyFields(["name_allergy"]) ,postAllergys);  

module.exports = router;