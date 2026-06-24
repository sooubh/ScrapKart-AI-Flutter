const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');

// Route: POST /api/auth/sync
router.post('/sync', authController.syncUser);

module.exports = router;
