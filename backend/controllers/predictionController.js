const pool = require('../config/db');
const { spawn } = require('child_process');
const path = require('path');

exports.predict = async (req, res) => {
    try {
        const { year, district, crop, season, rainfall_mm, avg_temp_c, area_ha } = req.body;

        if (!year || !district || !crop || !season || !rainfall_mm || !avg_temp_c || !area_ha) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        const inputData = JSON.stringify({
            year: parseInt(year), district, crop, season,
            rainfall_mm: parseFloat(rainfall_mm),
            avg_temp_c: parseFloat(avg_temp_c),
            area_ha: parseFloat(area_ha)
        });

        const pythonPath = process.env.PYTHON_PATH || 'python';
        const scriptPath = path.join(__dirname, '../ml/predict.py');

        const pythonProcess = spawn(pythonPath, [scriptPath, inputData]);

        let result = '';
        let error = '';

        pythonProcess.stdout.on('data', (data) => { result += data.toString(); });
        pythonProcess.stderr.on('data', (data) => { error += data.toString(); });

        pythonProcess.on('close', async (code) => {
            if (code !== 0) {
                return res.status(500).json({ error: 'Prediction failed', details: error });
            }

            try {
                const prediction = JSON.parse(result);
                
                await pool.query(
                    `INSERT INTO predictions_log (year, district, crop, season, rainfall_mm, avg_temp_c, area_ha, predicted_yield)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
                    [year, district, crop, season, rainfall_mm, avg_temp_c, area_ha, prediction.predicted_yield]
                );

                res.json(prediction);
            } catch (parseError) {
                res.status(500).json({ error: 'Failed to parse prediction result' });
            }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getPredictionHistory = async (req, res) => {
    try {
        const [rows] = await pool.query(
            'SELECT * FROM predictions_log ORDER BY created_at DESC LIMIT 100'
        );
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};