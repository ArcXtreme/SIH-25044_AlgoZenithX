import requests
from typing import Optional, Dict

# Get your free API key from: https://openweathermap.org/api
OPENWEATHER_API_KEY = "9ce2218fcaa4e021e7b5015bc8224624"  # Replace with your key
OPENWEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"

def get_weather_data(latitude: float, longitude: float) -> Optional[Dict]:
    """
    Fetch current weather data from OpenWeather API
    
    Args:
        latitude: Field latitude
        longitude: Field longitude
    
    Returns:
        Dictionary with weather data or None if API fails
    """
    try:
        params = {
            "lat": latitude,
            "lon": longitude,
            "appid": OPENWEATHER_API_KEY,
            "units": "metric"  # Celsius
        }
        
        response = requests.get(OPENWEATHER_URL, params=params, timeout=5)
        response.raise_for_status()
        
        data = response.json()
        
        # Extract relevant weather parameters
        weather_info = {
            "temperature": data["main"]["temp"],
            "humidity": data["main"]["humidity"],
            "pressure": data["main"]["pressure"],
            "rainfall": data.get("rain", {}).get("1h", 0),  # Last 1 hour
            "wind_speed": data["wind"]["speed"],
            "cloud_cover": data["clouds"]["all"]
        }
        
        return weather_info
        
    except requests.exceptions.RequestException as e:
        print(f"Error fetching weather data: {e}")
        return None
