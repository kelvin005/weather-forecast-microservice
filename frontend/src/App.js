import React, { useState } from 'react';
import Weather from './components/Weather';
import SearchForm from './components/SearchForm';

function App() {
  const [weather, setWeather] = useState(null);
  const [forecast, setForecast] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleSearch = (weatherData, forecastData) => {
    setWeather(weatherData);
    setForecast(forecastData);
  };

  const handleLoading = (isLoading) => {
    setLoading(isLoading);
  };

  const handleError = (errorMsg) => {
    setError(errorMsg);
  };

  return (
    <div style={{
      minHeight: '100vh',
      padding: '20px',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center'
    }}>
      <h1 style={{
        color: 'white',
        textAlign: 'center',
        marginBottom: '30px',
        fontSize: '2.5rem',
        textShadow: '2px 2px 4px rgba(0,0,0,0.3)'
      }}>
        Weather App
      </h1>
      
      <SearchForm 
        onSearch={handleSearch}
        onLoading={handleLoading}
        onError={handleError}
      />
      
      {loading && (
        <div style={{
          color: 'white',
          fontSize: '1.2rem',
          marginTop: '20px'
        }}>
          Loading...
        </div>
      )}
      
      {error && (
        <div style={{
          color: '#ff7675',
          backgroundColor: 'rgba(255, 255, 255, 0.1)',
          padding: '15px',
          borderRadius: '8px',
          marginTop: '20px',
          maxWidth: '400px',
          textAlign: 'center'
        }}>
          {error}
        </div>
      )}
      
      {weather && <Weather weather={weather} forecast={forecast} />}
    </div>
  );
}

export default App;