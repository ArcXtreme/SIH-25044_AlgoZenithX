const express = require('express');
const router = express.Router();
const modelController = require('../controllers/modelController');

router.post('/train', modelController.trainModel);
router.get('/status', modelController.getModelStatus);
router.get('/metrics', modelController.getModelMetrics);

module.exports = router;