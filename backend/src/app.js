const express = require('express');
const cors = require('cors');
require('dotenv').config();

const weatherRoutes = require('./routes/weather');

const app = express();
const PORT = process.env.PORT || 8080;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api', weatherRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    service: 'weather-backend',
    timestamp: new Date().toISOString()
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Weather Backend running on port ${PORT}`);
});