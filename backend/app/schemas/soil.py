from pydantic import BaseModel
from datetime import datetime

class SoilDataOut(BaseModel):
    id: int
    field_id: int
    nitrogen: float
    phosphorus: float
    potassium: float
    ph: float
    moisture: float
    organic_matter: float
    soil_type: str
    fetched_at: datetime

    class Config:
        from_attributes = True

class SoilInput(BaseModel):
    field_id: int
