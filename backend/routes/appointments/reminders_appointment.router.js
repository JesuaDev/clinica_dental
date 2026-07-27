const express = require('express');
const router = express.Router();

const { getReminder, getRemindersUpComing } =  require('../../controllers/appointments/reminder/reminder_get.controller');
const { postReminder} =  require('../../controllers/appointments/reminder/reminder_post.controller');
 const {verifyFields } = require ('../../middleware/verifyFields.middleware');

 router.post('/reminder',verifyFields(["title_reminder", "date_init", "date_limit", "id_user"]), postReminder);
router.get('/reminders', getReminder);  
router.get('/reminders/upcoming', getRemindersUpComing);
//router.get('/reminder/:id'); 


module.exports = router; 