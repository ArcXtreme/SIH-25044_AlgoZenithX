from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from backend.app.database import get_db
from backend.app.routers.auth import get_current_user
from backend.app.models.crop import Field, Prediction
from backend.app.models.weather import WeatherData
from backend.app.models.soil import SoilData
from backend.app import crud
from pydantic import BaseModel

router = APIRouter()

class DashboardStats(BaseModel):
    total_fields: int
    total_predictions: int
    average_yield: float
    latest_weather_temp: float = None
    latest_soil_ph: float = None

@router.get("/analytics/dashboard", response_model=DashboardStats)
def get_dashboard_stats(
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get dashboard statistics for the farmer"""
    
    # Total fields
    total_fields = db.query(Field).filter(Field.user_id == current_user.id).count()
    
    # Total predictions
    user_field_ids = db.query(Field.id).filter(Field.user_id == current_user.id).subquery()
    total_predictions = db.query(Prediction).filter(Prediction.field_id.in_(user_field_ids)).count()
    
    # Average yield from predictions
    avg_yield_result = db.query(func.avg(Prediction.predicted_yield)).filter(
        Prediction.field_id.in_(user_field_ids)
    ).scalar()
    average_yield = float(avg_yield_result) if avg_yield_result else 0.0
    
    # Latest weather (across all fields)
    latest_weather = db.query(WeatherData).filter(
        WeatherData.field_id.in_(user_field_ids)
    ).order_by(WeatherData.fetched_at.desc()).first()
    latest_weather_temp = latest_weather.temperature if latest_weather else None
    
    # Latest soil (across all fields)
    latest_soil = db.query(SoilData).filter(
        SoilData.field_id.in_(user_field_ids)
    ).order_by(SoilData.fetched_at.desc()).first()
    latest_soil_ph = latest_soil.ph if latest_soil else None
    
    return DashboardStats(
        total_fields=total_fields,
        total_predictions=total_predictions,
        average_yield=average_yield,
        latest_weather_temp=latest_weather_temp,
        latest_soil_ph=latest_soil_ph
    )

@router.get("/analytics/field/{field_id}")
def get_field_analytics(
    field_id: int,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get detailed analytics for a specific field"""
    
    field = crud.get_field(db=db, field_id=field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    # Get all data for this field
    predictions = db.query(Prediction).filter(Prediction.field_id == field_id).all()
    weather_history = db.query(WeatherData).filter(WeatherData.field_id == field_id).all()
    soil_history = db.query(SoilData).filter(SoilData.field_id == field_id).all()
    
    return {
        "field": {
            "id": field.id,
            "name": field.field_name,
            "area": field.area_in_hectares,
            "soil_type": field.soil_type,
            "location": {
                "latitude": field.location_latitude,
                "longitude": field.location_longitude
            }
        },
        "predictions_count": len(predictions),
        "avg_yield": sum(p.predicted_yield for p in predictions) / len(predictions) if predictions else 0,
        "weather_records": len(weather_history),
        "soil_records": len(soil_history),
        "latest_prediction": {
            "yield": predictions[-1].predicted_yield if predictions else None,
            "crop": predictions[-1].crop_type if predictions else None,
            "confidence": predictions[-1].confidence_score if predictions else None
        } if predictions else None
    }

@router.get("/analytics/recommendations/{field_id}")
def get_recommendations(
    field_id: int,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get latest recommendations for a field"""
    
    field = crud.get_field(db=db, field_id=field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    latest_prediction = db.query(Prediction).filter(
        Prediction.field_id == field_id
    ).order_by(Prediction.created_at.desc()).first()
    
    if not latest_prediction:
        raise HTTPException(status_code=404, detail="No predictions found for this field")
    
    return {
        "crop": latest_prediction.crop_type,
        "predicted_yield": latest_prediction.predicted_yield,
        "confidence": latest_prediction.confidence_score,
        "irrigation": latest_prediction.irrigation_recommendation,
        "fertilizer": latest_prediction.fertilizer_recommendation,
        "pest_control": latest_prediction.pest_recommendation,
        "generated_at": latest_prediction.created_at
    }
