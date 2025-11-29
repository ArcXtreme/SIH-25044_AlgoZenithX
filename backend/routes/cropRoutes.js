const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const cropController = require('../controllers/cropController');

const storage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, path.join(__dirname, '../uploads')),
    filename: (req, file, cb) => cb(null, `upload-${Date.now()}.csv`)
});

const upload = multer({ 
    storage,
    fileFilter: (req, file, cb) => {
        if (file.mimetype === 'text/csv' || file.originalname.endsWith('.csv')) {
            cb(null, true);
        } else {
            cb(new Error('Only CSV files allowed'));
        }
    }
});

router.get('/', cropController.getAllData);
router.get('/options', cropController.getOptions);
router.get('/statistics', cropController.getStatistics);
router.get('/export', cropController.exportCSV);
router.get('/:id', cropController.getDataById);
router.post('/', cropController.addData);
router.put('/:id', cropController.updateData);
router.delete('/:id', cropController.deleteData);
router.post('/bulk-delete', cropController.bulkDelete);
router.post('/upload', upload.single('file'), cropController.uploadCSV);

module.exports = router;