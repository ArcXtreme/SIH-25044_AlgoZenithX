from sqlalchemy import Column, Integer, Float, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from backend.app.database import Base

class SoilData(Base):
    __tablename__ = "soil_data"

    id = Column(Integer, primary_key=True, index=True)
    field_id = Column(Integer, ForeignKey("fields.id"), nullable=False)
    
    # Soil parameters
    nitrogen = Column(Float)  # mg/kg
    phosphorus = Column(Float)  # mg/kg
    potassium = Column(Float)  # mg/kg
    ph = Column(Float)  # pH level (0-14)
    moisture = Column(Float)  # Percentage
    organic_matter = Column(Float)  # Percentage
    soil_type = Column(String)  # Clay, Loam, Sandy, etc.
    
    # Metadata
    fetched_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationship
    field = relationship("Field", back_populates="soil_data")
