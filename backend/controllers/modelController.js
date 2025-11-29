const pool = require('../config/db');
const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const { format } = require('fast-csv');

exports.trainModel = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM crop_data_view ORDER BY year');

        if (rows.length < 10) {
            return res.status(400).json({ error: 'Need at least 10 records to train model' });
        }

        const csvPath = path.join(__dirname, '../ml/training_data.csv');
        const writeStream = fs.createWriteStream(csvPath);
        const csvStream = format({ headers: true });

        csvStream.pipe(writeStream);

        rows.forEach(row => {
            csvStream.write({
                Year: row.year, District: row.district, Crop: row.crop, Season: row.season,
                Rainfall_mm: row.rainfall_mm, Avg_Temp_C: row.avg_temp_c,
                Area_Ha: row.area_ha, Yield_t_ha: row.yield_t_ha
            });
        });

        csvStream.end();

        writeStream.on('finish', () => {
            const pythonPath = process.env.PYTHON_PATH || 'python';
            const scriptPath = path.join(__dirname, '../ml/train_model.py');

            const pythonProcess = spawn(pythonPath, [scriptPath, csvPath]);

            let result = '';
            let error = '';

            pythonProcess.stdout.on('data', (data) => { result += data.toString(); });
            pythonProcess.stderr.on('data', (data) => { error += data.toString(); });

            pythonProcess.on('close', async (code) => {
                if (code !== 0) {
                    await pool.query(
                        `INSERT INTO model_training_log (records_used, status, error_message) VALUES (?, 'failed', ?)`,
                        [rows.length, error]
                    );
                    return res.status(500).json({ error: 'Training failed', details: error });
                }

                try {
                    const metrics = JSON.parse(result);

                    await pool.query(
                        `INSERT INTO model_training_log (records_used, mse, rmse, mae, r2_score, status)
                         VALUES (?, ?, ?, ?, ?, 'success')`,
                        [rows.length, metrics.mse, metrics.rmse, metrics.mae, metrics.r2_score]
                    );

                    res.json({ message: 'Model trained successfully', records_used: rows.length, metrics });
                } catch (parseError) {
                    res.status(500).json({ error: 'Failed to parse training results' });
                }
            });
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getModelStatus = async (req, res) => {
    try {
        const modelPath = path.join(__dirname, '../ml/model/xgboost_model.joblib');
        const modelExists = fs.existsSync(modelPath);

        const [lastTraining] = await pool.query(
            'SELECT * FROM model_training_log ORDER BY training_date DESC LIMIT 1'
        );

        const [trainingHistory] = await pool.query(
            'SELECT * FROM model_training_log ORDER BY training_date DESC LIMIT 10'
        );

        res.json({ modelExists, lastTraining: lastTraining[0] || null, trainingHistory });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getModelMetrics = async (req, res) => {
    try {
        const [metrics] = await pool.query(
            'SELECT * FROM model_training_log WHERE status = "success" ORDER BY training_date DESC LIMIT 1'
        );

        if (metrics.length === 0) {
            return res.status(404).json({ error: 'No trained model found' });
        }

        res.json(metrics[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};