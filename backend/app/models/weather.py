from sqlalchemy import Column, Integer, Float, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from backend.app.database import Base

class WeatherData(Base):
    __tablename__ = "weather_data"

    id = Column(Integer, primary_key=True, index=True)
    field_id = Column(Integer, ForeignKey("fields.id"), nullable=False)
    
    # Weather parameters
    temperature = Column(Float)  # Celsius
    humidity = Column(Float)  # Percentage
    rainfall = Column(Float)  # mm
    wind_speed = Column(Float)  # m/s
    pressure = Column(Float)  # hPa
    cloud_cover = Column(Float)  # Percentage
    
    # Metadata
    fetched_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationship
    field = relationship("Field", back_populates="weather_data")
