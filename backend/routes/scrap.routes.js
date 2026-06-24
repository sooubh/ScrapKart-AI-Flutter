const express = require('express');
const router = express.Router();
const scrapController = require('../controllers/scrap.controller');

// Expose POST endpoint to scan and run AI inference
router.post('/scan-scrap', scrapController.upload.single('image'), scrapController.scanScrap);

module.exports = router;
