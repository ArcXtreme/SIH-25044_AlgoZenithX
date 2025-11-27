from pydantic import BaseModel
from typing import Optional
from datetime import datetime

# For creating a field
class FieldCreate(BaseModel):
    field_name: str
    location_latitude: float
    location_longitude: float
    area_in_hectares: float
    soil_type: str

# For returning field data
class FieldOut(BaseModel):
    id: int
    field_name: str
    location_latitude: float
    location_longitude: float
    area_in_hectares: float
    soil_type: str
    created_at: datetime

    class Config:
        from_attributes = True

# For prediction input
class PredictionInput(BaseModel):
    field_id: int
    crop_type: str
    # You can add more fields like weather data, historical yield, etc.

# For prediction output (recommendations)
class PredictionOutput(BaseModel):
    id: int
    crop_type: str
    predicted_yield: float
    confidence_score: float
    irrigation_recommendation: str
    fertilizer_recommendation: str
    pest_recommendation: str
    created_at: datetime

    class Config:
        from_attributes = True
