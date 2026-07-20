const express = require('express');
const router = express.Router();

const { postUser, getUsers } = require('../../controllers/users/users.controller');
const { verifyToken } = require('../../middleware/verifyToken.middleware');

router.get('/users', verifyToken, getUsers);
router.post('/user', verifyToken, postUser);

module.exports = router; 