const express = require('express');
const router = express.Router();
const predictionController = require('../controllers/predictionController');

router.post('/', predictionController.predict);
router.get('/history', predictionController.getPredictionHistory);

module.exports = router;