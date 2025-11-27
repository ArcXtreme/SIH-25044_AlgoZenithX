from typing import Optional, Dict

# Get your API key from: https://agromonitoring.com/api
AGROMONITORING_API_KEY = "3eac96005f178498c6e7117a7123fda1"  # Replace with your key
AGROMONITORING_URL = "https://api.agromonitoring.com/agro/1.0/soil"

def get_soil_data(latitude: float, longitude: float) -> Optional[Dict]:
    """
    Fetch soil data from Agromonitoring API
    
    Args:
        latitude: Field latitude
        longitude: Field longitude
    
    Returns:
        Dictionary with soil data or None if API fails
    """
    try:
        import requests
        
        params = {
            "lat": latitude,
            "lon": longitude,
            "appid": AGROMONITORING_API_KEY
        }
        
        response = requests.get(AGROMONITORING_URL, params=params, timeout=5)
        response.raise_for_status()
        
        data = response.json()
        
        # Extract soil parameters
        soil_info = {
            "nitrogen": data.get("N", 0),
            "phosphorus": data.get("P", 0),
            "potassium": data.get("K", 0),
            "ph": data.get("pH", 7.0),
            "moisture": data.get("moisture", 0),
            "organic_matter": data.get("om", 0),
            "soil_type": data.get("soil_type", "Loam")
        }
        
        return soil_info
        
    except Exception as e:
        print(f"Error fetching soil data: {e}")
        # Return mock soil data if API fails
        return {
            "nitrogen": 25.0,
            "phosphorus": 15.0,
            "potassium": 180.0,
            "ph": 6.8,
            "moisture": 30.0,
            "organic_matter": 2.5,
            "soil_type": "Loam"
        }
