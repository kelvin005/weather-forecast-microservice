const express = require('express');
const { getWeather, getForecast } = require('../controllers/weatherController');

const router = express.Router();

router.get('/weather/:city', getWeather);
router.get('/forecast/:city', getForecast);

module.exports = router;