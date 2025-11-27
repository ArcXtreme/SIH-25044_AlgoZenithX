from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from backend.app.database import Base

class Field(Base):
    __tablename__ = "fields"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)  # Link to farmer
    field_name = Column(String, index=True)
    location_latitude = Column(Float)  # For geo-tagging
    location_longitude = Column(Float)
    area_in_hectares = Column(Float)
    soil_type = Column(String)  # e.g., "Loamy", "Clay", "Sandy"
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationship
    user = relationship("User", back_populates="fields")
    predictions = relationship("Prediction", back_populates="field")

class Prediction(Base):
    __tablename__ = "predictions"

    id = Column(Integer, primary_key=True, index=True)
    field_id = Column(Integer, ForeignKey("fields.id"), nullable=False)
    crop_type = Column(String)  # e.g., "Rice", "Wheat", "Cotton"
    predicted_yield = Column(Float)  # in quintals/hectare
    confidence_score = Column(Float)  # 0-1
    irrigation_recommendation = Column(String)
    fertilizer_recommendation = Column(String)
    pest_recommendation = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationship
    field = relationship("Field", back_populates="predictions")
