const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/booking.controller');

router.post('/assign-collector', bookingController.assignCollector);

module.exports = router;
