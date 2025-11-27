from pydantic import BaseModel

class PredictionInput(BaseModel):
    location: str  # e.g., "Punjab"
    crop_type: str  # e.g., "Wheat"
    soil_type: str  # e.g., "Loamy"
    area_in_hectares: float
    season: str  # e.g., "Kharif" or "Rabi"

class PredictionOutput(BaseModel):
    predicted_yield: float
    unit: str
    confidence: str
    irrigation_recommendation: str
    fertilizer_recommendation: str
    pest_recommendation: str
