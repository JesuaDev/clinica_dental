const express = require('express');
const router = express.Router();

const { getReminder, postReminder, getRemindersUpComing } =  require('../../controllers/users/calendar.controller');
 const {verifyFields } = require ('../../middleware/verifyFields.middleware');

 router.post('/reminder',verifyFields(["title_reminder", "date_init", "date_limit", "id_user"]), postReminder);
router.get('/reminders', getReminder);  
router.get('/reminders/upcoming', getRemindersUpComing);
//router.get('/reminder/:id'); 


module.exports = router; 