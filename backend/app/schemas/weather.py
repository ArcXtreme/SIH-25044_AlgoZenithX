from pydantic import BaseModel
from datetime import datetime

class WeatherDataOut(BaseModel):
    id: int
    field_id: int
    temperature: float
    humidity: float
    rainfall: float
    wind_speed: float
    pressure: float
    cloud_cover: float
    fetched_at: datetime

    class Config:
        from_attributes = True

class WeatherInput(BaseModel):
    field_id: int
