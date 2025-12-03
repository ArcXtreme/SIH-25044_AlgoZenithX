"""
Weather Service - Fetches weather data from OpenWeatherMap API
"""
import httpx
from typing import Dict, Any, Optional
from app.core.config import settings
import logging

logger = logging.getLogger(__name__)

class WeatherService:
    def __init__(self):
        self.api_key = settings.OPENWEATHER_API_KEY
        self.base_url = "https://api.openweathermap.org/data/2.5"
    
    async def get_current_weather(self, latitude: float, longitude: float) -> Optional[Dict[str, Any]]:
        """
        Fetch current weather data for given coordinates
        
        Args:
            latitude: Latitude of the location
            longitude: Longitude of the location
            
        Returns:
            Dictionary containing weather data or None if error
        """
        if not self.api_key:
            logger.warning("OpenWeatherMap API key not configured")
            return None
        
        try:
            url = f"{self.base_url}/weather"
            params = {
                "lat": latitude,
                "lon": longitude,
                "appid": self.api_key,
                "units": "metric"  # Get temperature in Celsius
            }
            
            async with httpx.AsyncClient(timeout=10.0) as client:
                response = await client.get(url, params=params)
                response.raise_for_status()
                data = response.json()
                
                # Extract relevant weather information
                weather_info = {
                    "temperature": data.get("main", {}).get("temp"),
                    "feels_like": data.get("main", {}).get("feels_like"),
                    "humidity": data.get("main", {}).get("humidity"),
                    "pressure": data.get("main", {}).get("pressure"),
                    "wind_speed": data.get("wind", {}).get("speed"),
                    "wind_direction": data.get("wind", {}).get("deg"),
                    "visibility": data.get("visibility"),
                    "uv_index": None,  # UV index requires separate API call
                    "precipitation": data.get("rain", {}).get("1h", 0) or data.get("rain", {}).get("3h", 0),
                    "weather_description": data.get("weather", [{}])[0].get("description", ""),
                    "weather_icon": data.get("weather", [{}])[0].get("icon", ""),
                    "clouds": data.get("clouds", {}).get("all", 0),
                    "sunrise": data.get("sys", {}).get("sunrise"),
                    "sunset": data.get("sys", {}).get("sunset"),
                    "raw_data": data  # Store full response for reference
                }
                
                return weather_info
                
        except httpx.HTTPError as e:
            logger.error(f"Error fetching weather data: {str(e)}")
            return None
        except Exception as e:
            logger.error(f"Unexpected error in weather service: {str(e)}")
            return None
    
    async def get_forecast(self, latitude: float, longitude: float, days: int = 5) -> Optional[Dict[str, Any]]:
        """
        Fetch weather forecast for given coordinates
        
        Args:
            latitude: Latitude of the location
            longitude: Longitude of the location
            days: Number of days to forecast (default: 5)
            
        Returns:
            Dictionary containing forecast data or None if error
        """
        if not self.api_key:
            logger.warning("OpenWeatherMap API key not configured")
            return None
        
        try:
            url = f"{self.base_url}/forecast"
            params = {
                "lat": latitude,
                "lon": longitude,
                "appid": self.api_key,
                "units": "metric",
                "cnt": days * 8  # 8 forecasts per day (3-hour intervals)
            }
            
            async with httpx.AsyncClient(timeout=10.0) as client:
                response = await client.get(url, params=params)
                response.raise_for_status()
                data = response.json()
                
                # Process forecast list
                forecast_list = []
                for item in data.get("list", [])[:days * 8]:
                    forecast_list.append({
                        "datetime": item.get("dt"),
                        "temperature": item.get("main", {}).get("temp"),
                        "humidity": item.get("main", {}).get("humidity"),
                        "pressure": item.get("main", {}).get("pressure"),
                        "wind_speed": item.get("wind", {}).get("speed"),
                        "precipitation": item.get("rain", {}).get("3h", 0),
                        "weather_description": item.get("weather", [{}])[0].get("description", ""),
                        "weather_icon": item.get("weather", [{}])[0].get("icon", "")
                    })
                
                return {
                    "forecast": forecast_list,
                    "city": data.get("city", {}).get("name", ""),
                    "country": data.get("city", {}).get("country", "")
                }
                
        except httpx.HTTPError as e:
            logger.error(f"Error fetching weather forecast: {str(e)}")
            return None
        except Exception as e:
            logger.error(f"Unexpected error in weather forecast service: {str(e)}")
            return None

# Singleton instance
weather_service = WeatherService()

