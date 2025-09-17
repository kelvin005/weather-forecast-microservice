const WeatherService = require('../utils/weatherService');

const getWeather = async (req, res) => {
  try {
    const { city } = req.params;
    const weather = await WeatherService.getCurrentWeather(city);
    res.json(weather);
  } catch (error) {
    res.status(500).json({
      error: 'Failed to fetch weather data',
      message: error.message
    });
  }
};

const getForecast = async (req, res) => {
  try {
    const { city } = req.params;
    const forecast = await WeatherService.getForecast(city);
    res.json(forecast);
  } catch (error) {
    res.status(500).json({
      error: 'Failed to fetch forecast data',
      message: error.message
    });
  }
};

module.exports = {
  getWeather,
  getForecast
};