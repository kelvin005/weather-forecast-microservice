import axios from 'axios';

const API_BASE_URL = 'api';

class WeatherApi {
  async getWeather(city) {
    try {
      const response = await axios.get(`${API_BASE_URL}/weather/${encodeURIComponent(city)}`);
      return response.data;
    } catch (error) {
      throw new Error(error.response?.data?.message || 'Failed to fetch weather data');
    }
  }

  async getForecast(city) {
    try {
      const response = await axios.get(`${API_BASE_URL}/forecast/${encodeURIComponent(city)}`);
      return response.data;
    } catch (error) {
      throw new Error(error.response?.data?.message || 'Failed to fetch forecast data');
    }
  }
}

export default new WeatherApi();