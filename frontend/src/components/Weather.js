import React from 'react';

function Weather({ weather, forecast }) {
  if (!weather) return null;

  const cardStyle = {
    backgroundColor: 'rgba(255, 255, 255, 0.1)',
    backdropFilter: 'blur(10px)',
    borderRadius: '20px',
    padding: '25px',
    margin: '10px',
    color: 'white',
    boxShadow: '0 8px 32px rgba(0,0,0,0.1)',
    border: '1px solid rgba(255, 255, 255, 0.2)'
  };

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      maxWidth: '800px',
      width: '100%'
    }}>
      {/* Current Weather */}
      <div style={{
        ...cardStyle,
        textAlign: 'center',
        marginBottom: '20px',
        minWidth: '300px'
      }}>
        <h2 style={{ margin: '0 0 15px 0', fontSize: '1.8rem' }}>
          {weather.city}, {weather.country}
        </h2>
        <div style={{ fontSize: '3rem', margin: '15px 0' }}>
          {Math.round(weather.temperature)}°C
        </div>
        <div style={{
          fontSize: '1.2rem',
          textTransform: 'capitalize',
          marginBottom: '15px'
        }}>
          {weather.description}
        </div>
        <div style={{
          display: 'flex',
          justifyContent: 'space-around',
          fontSize: '0.9rem',
          opacity: 0.8
        }}>
          <div>Humidity: {weather.humidity}%</div>
          <div>Wind: {weather.windSpeed} m/s</div>
        </div>
      </div>

      {/* Forecast */}
      {forecast && forecast.length > 0 && (
        <div style={{ ...cardStyle, width: '100%' }}>
          <h3 style={{ margin: '0 0 20px 0', textAlign: 'center' }}>
            5-Day Forecast
          </h3>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(140px, 1fr))',
            gap: '15px'
          }}>
            {forecast.map((day, index) => (
              <div key={index} style={{
                textAlign: 'center',
                padding: '15px',
                backgroundColor: 'rgba(255, 255, 255, 0.05)',
                borderRadius: '10px'
              }}>
                <div style={{ fontSize: '0.9rem', marginBottom: '8px' }}>
                  {new Date(day.date).toLocaleDateString('en-US', { 
                    weekday: 'short',
                    month: 'short',
                    day: 'numeric'
                  })}
                </div>
                <div style={{ fontSize: '1.2rem', margin: '8px 0' }}>
                  {Math.round(day.temperature)}°C
                </div>
                <div style={{
                  fontSize: '0.8rem',
                  textTransform: 'capitalize',
                  opacity: 0.8
                }}>
                  {day.description}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

export default Weather;