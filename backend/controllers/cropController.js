const pool = require('../config/db');
const fs = require('fs');
const csv = require('csv-parser');
const { format } = require('fast-csv');

// Get all crop data
exports.getAllData = async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 50;
        const offset = (page - 1) * limit;

        const [rows] = await pool.query(
            'SELECT * FROM crop_data_view ORDER BY year DESC, district LIMIT ? OFFSET ?',
            [limit, offset]
        );

        const [countResult] = await pool.query('SELECT COUNT(*) as total FROM crop_data');
        const total = countResult[0].total;

        res.json({
            data: rows,
            pagination: {
                page,
                limit,
                total,
                totalPages: Math.ceil(total / limit)
            }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get single record
exports.getDataById = async (req, res) => {
    try {
        const [rows] = await pool.query(
            'SELECT * FROM crop_data_view WHERE id = ?',
            [req.params.id]
        );

        if (rows.length === 0) {
            return res.status(404).json({ error: 'Record not found' });
        }

        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Add new record
exports.addData = async (req, res) => {
    try {
        const { year, district, crop, season, rainfall_mm, avg_temp_c, area_ha, yield_t_ha } = req.body;

        if (!year || !district || !crop || !season || !rainfall_mm || !avg_temp_c || !area_ha || !yield_t_ha) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        const [districtResult] = await pool.query('SELECT id FROM districts WHERE name = ?', [district]);
        const [cropResult] = await pool.query('SELECT id FROM crops WHERE name = ?', [crop]);
        const [seasonResult] = await pool.query('SELECT id FROM seasons WHERE name = ?', [season]);

        if (districtResult.length === 0 || cropResult.length === 0 || seasonResult.length === 0) {
            return res.status(400).json({ error: 'Invalid district, crop, or season' });
        }

        const [result] = await pool.query(
            `INSERT INTO crop_data (year, district_id, crop_id, season_id, rainfall_mm, avg_temp_c, area_ha, yield_t_ha) 
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
            [year, districtResult[0].id, cropResult[0].id, seasonResult[0].id, rainfall_mm, avg_temp_c, area_ha, yield_t_ha]
        );

        res.status(201).json({ message: 'Record added successfully', id: result.insertId });
    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ error: 'Duplicate record exists' });
        }
        res.status(500).json({ error: error.message });
    }
};

// Update record
exports.updateData = async (req, res) => {
    try {
        const { id } = req.params;
        const { year, district, crop, season, rainfall_mm, avg_temp_c, area_ha, yield_t_ha } = req.body;

        const [districtResult] = await pool.query('SELECT id FROM districts WHERE name = ?', [district]);
        const [cropResult] = await pool.query('SELECT id FROM crops WHERE name = ?', [crop]);
        const [seasonResult] = await pool.query('SELECT id FROM seasons WHERE name = ?', [season]);

        if (districtResult.length === 0 || cropResult.length === 0 || seasonResult.length === 0) {
            return res.status(400).json({ error: 'Invalid district, crop, or season' });
        }

        const [result] = await pool.query(
            `UPDATE crop_data SET year = ?, district_id = ?, crop_id = ?, season_id = ?, 
             rainfall_mm = ?, avg_temp_c = ?, area_ha = ?, yield_t_ha = ? WHERE id = ?`,
            [year, districtResult[0].id, cropResult[0].id, seasonResult[0].id, 
             rainfall_mm, avg_temp_c, area_ha, yield_t_ha, id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Record not found' });
        }

        res.json({ message: 'Record updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Delete record
exports.deleteData = async (req, res) => {
    try {
        const [result] = await pool.query('DELETE FROM crop_data WHERE id = ?', [req.params.id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Record not found' });
        }

        res.json({ message: 'Record deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Bulk delete
exports.bulkDelete = async (req, res) => {
    try {
        const { ids } = req.body;
        
        if (!ids || !Array.isArray(ids) || ids.length === 0) {
            return res.status(400).json({ error: 'Invalid IDs provided' });
        }

        const [result] = await pool.query('DELETE FROM crop_data WHERE id IN (?)', [ids]);
        res.json({ message: `${result.affectedRows} records deleted successfully` });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get dropdown options
exports.getOptions = async (req, res) => {
    try {
        const [districts] = await pool.query('SELECT name FROM districts ORDER BY name');
        const [crops] = await pool.query('SELECT name FROM crops ORDER BY name');
        const [seasons] = await pool.query('SELECT name FROM seasons ORDER BY name');
        const [years] = await pool.query('SELECT DISTINCT year FROM crop_data ORDER BY year DESC');

        res.json({
            districts: districts.map(d => d.name),
            crops: crops.map(c => c.name),
            seasons: seasons.map(s => s.name),
            years: years.map(y => y.year)
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get statistics
exports.getStatistics = async (req, res) => {
    try {
        const [totalRecords] = await pool.query('SELECT COUNT(*) as count FROM crop_data');
        const [avgYield] = await pool.query('SELECT AVG(yield_t_ha) as avg FROM crop_data');
        const [yieldByCrop] = await pool.query(`
            SELECT c.name as crop, AVG(cd.yield_t_ha) as avg_yield, COUNT(*) as count
            FROM crop_data cd JOIN crops c ON cd.crop_id = c.id GROUP BY c.name
        `);
        const [yieldByDistrict] = await pool.query(`
            SELECT d.name as district, AVG(cd.yield_t_ha) as avg_yield
            FROM crop_data cd JOIN districts d ON cd.district_id = d.id GROUP BY d.name
        `);
        const [yearlyTrend] = await pool.query(`
            SELECT year, AVG(yield_t_ha) as avg_yield FROM crop_data GROUP BY year ORDER BY year
        `);

        res.json({
            totalRecords: totalRecords[0].count,
            avgYield: avgYield[0].avg ? parseFloat(avgYield[0].avg).toFixed(4) : '0',
            yieldByCrop,
            yieldByDistrict,
            yearlyTrend
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Upload CSV
exports.uploadCSV = async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }

        const results = [];
        const errors = [];
        let processedCount = 0;

        const [districts] = await pool.query('SELECT id, name FROM districts');
        const [crops] = await pool.query('SELECT id, name FROM crops');
        const [seasons] = await pool.query('SELECT id, name FROM seasons');

        const districtMap = Object.fromEntries(districts.map(d => [d.name, d.id]));
        const cropMap = Object.fromEntries(crops.map(c => [c.name, c.id]));
        const seasonMap = Object.fromEntries(seasons.map(s => [s.name, s.id]));

        fs.createReadStream(req.file.path)
            .pipe(csv())
            .on('data', (row) => results.push(row))
            .on('end', async () => {
                for (const row of results) {
                    try {
                        const districtId = districtMap[row.District];
                        const cropId = cropMap[row.Crop];
                        const seasonId = seasonMap[row.Season];

                        if (!districtId || !cropId || !seasonId) {
                            errors.push({ row, error: 'Invalid district, crop, or season' });
                            continue;
                        }

                        await pool.query(
                            `INSERT INTO crop_data (year, district_id, crop_id, season_id, rainfall_mm, avg_temp_c, area_ha, yield_t_ha) 
                             VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                             ON DUPLICATE KEY UPDATE 
                             rainfall_mm = VALUES(rainfall_mm), avg_temp_c = VALUES(avg_temp_c),
                             area_ha = VALUES(area_ha), yield_t_ha = VALUES(yield_t_ha)`,
                            [row.Year, districtId, cropId, seasonId, row.Rainfall_mm, row.Avg_Temp_C, row.Area_Ha, row.Yield_t_ha]
                        );
                        processedCount++;
                    } catch (err) {
                        errors.push({ row, error: err.message });
                    }
                }

                fs.unlinkSync(req.file.path);
                res.json({ message: 'CSV processed', processed: processedCount, errors: errors.length });
            });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Export CSV
exports.exportCSV = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM crop_data_view ORDER BY year, district');

        res.setHeader('Content-Type', 'text/csv');
        res.setHeader('Content-Disposition', 'attachment; filename=crop_data_export.csv');

        const csvStream = format({ headers: true });
        csvStream.pipe(res);

        rows.forEach(row => {
            csvStream.write({
                Year: row.year, District: row.district, Crop: row.crop, Season: row.season,
                Rainfall_mm: row.rainfall_mm, Avg_Temp_C: row.avg_temp_c,
                Area_Ha: row.area_ha, Yield_t_ha: row.yield_t_ha
            });
        });

        csvStream.end();
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};