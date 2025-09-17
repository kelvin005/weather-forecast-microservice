import React, { useState } from 'react';
import weatherApi from '../services/weatherApi';

function SearchForm({ onSearch, onLoading, onError }) {
  const [city, setCity] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!city.trim()) return;

    onLoading(true);
    onError(null);

    try {
      const [weatherData, forecastData] = await Promise.all([
        weatherApi.getWeather(city),
        weatherApi.getForecast(city)
      ]);
      
      onSearch(weatherData, forecastData);
    } catch (error) {
      onError(error.message || 'Failed to fetch weather data');
    } finally {
      onLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} style={{
      display: 'flex',
      gap: '10px',
      marginBottom: '30px',
      maxWidth: '400px',
      width: '100%'
    }}>
      <input
        type="text"
        value={city}
        onChange={(e) => setCity(e.target.value)}
        placeholder="Enter city name..."
        style={{
          flex: 1,
          padding: '12px 15px',
          borderRadius: '25px',
          border: 'none',
          fontSize: '16px',
          outline: 'none',
          boxShadow: '0 4px 15px rgba(0,0,0,0.1)'
        }}
      />
      <button
        type="submit"
        style={{
          padding: '12px 25px',
          borderRadius: '25px',
          border: 'none',
          backgroundColor: '#00b894',
          color: 'white',
          fontSize: '16px',
          cursor: 'pointer',
          boxShadow: '0 4px 15px rgba(0,0,0,0.1)',
          transition: 'all 0.3s ease'
        }}
        onMouseOver={(e) => e.target.style.backgroundColor = '#00a085'}
        onMouseOut={(e) => e.target.style.backgroundColor = '#00b894'}
      >
        Search
      </button>
    </form>
  );
}

export default SearchForm;