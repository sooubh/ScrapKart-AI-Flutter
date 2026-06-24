const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chat.controller');

// Expose strictly mapped POST Endpoint routing user-input directly to LLM
router.post('/', chatController.chat);

module.exports = router;
