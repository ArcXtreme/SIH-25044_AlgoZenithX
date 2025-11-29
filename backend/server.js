const express = require('express');
const cors = require('cors');
require('dotenv').config();

const cropRoutes = require('./routes/cropRoutes');
const predictionRoutes = require('./routes/predictionRoutes');
const modelRoutes = require('./routes/modelRoutes');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/crops', cropRoutes);
app.use('/api/predictions', predictionRoutes);
app.use('/api/model', modelRoutes);

// Health Check
app.get('/api/health', (req, res) => {
    res.json({ status: 'OK', message: 'Server is running' });
});

// Error Handler
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something went wrong!' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});