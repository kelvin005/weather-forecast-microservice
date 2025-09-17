require('dotenv').config();
const axios = require('axios');

class WeatherService {
  constructor() {
    this.apiKey = process.env.OPENWEATHER_API_KEY;
    this.baseUrl = 'https://api.openweathermap.org/data/2.5';
  }

  async getCurrentWeather(city) {
    if (!city) {
      throw new Error('City parameter is required');
    }

    // Mock data for demo purposes if no API key
    if (this.apiKey === 'demo-key') {
      return this.getMockWeather(city);
    }

    try {
      const response = await axios.get(`${this.baseUrl}/weather`, {
        params: {
          q: city,
          appid: this.apiKey,
          units: 'metric'
        }
      });

      return {
        city: response.data.name,
        country: response.data.sys.country,
        temperature: response.data.main.temp,
        description: response.data.weather[0].description,
        humidity: response.data.main.humidity,
        windSpeed: response.data.wind.speed,
        icon: response.data.weather[0].icon
      };
    } catch (error) {
      throw new Error(`Weather API error: ${error.message}`);
    }
  }

  async getForecast(city) {
    if (this.apiKey === 'demo-key') {
      return this.getMockForecast(city);
    }

    try {
      const response = await axios.get(`${this.baseUrl}/forecast`, {
        params: {
          q: city,
          appid: this.apiKey,
          units: 'metric'
        }
      });

      return response.data.list.slice(0, 5).map(item => ({
        date: item.dt_txt,
        temperature: item.main.temp,
        description: item.weather[0].description,
        icon: item.weather[0].icon
      }));
    } catch (error) {
      throw new Error(`Forecast API error: ${error.message}`);
    }
  }

  getMockWeather(city) {
    return {
      city: city,
      country: 'Demo',
      temperature: 22,
      description: 'partly cloudy',
      humidity: 65,
      windSpeed: 3.5,
      icon: '02d'
    };
  }

  getMockForecast(city) {
    return Array.from({ length: 5 }, (_, i) => ({
      date: new Date(Date.now() + i * 24 * 60 * 60 * 1000).toISOString(),
      temperature: 20 + Math.random() * 10,
      description: ['sunny', 'cloudy', 'rainy', 'partly cloudy'][Math.floor(Math.random() * 4)],
      icon: '01d'
    }));
  }
}

module.exports = new WeatherService();