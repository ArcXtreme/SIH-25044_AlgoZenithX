from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.database import get_db
from backend.app.schemas.weather import WeatherDataOut, WeatherInput
from backend.app.routers.auth import get_current_user
from backend.app.services.weather_service import get_weather_data
from backend.app import crud

router = APIRouter()

@router.post("/weather/fetch", response_model=WeatherDataOut)
def fetch_weather(
    weather_input: WeatherInput,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Fetch current weather data for a field"""
    # Verify field belongs to current user
    field = crud.get_field(db=db, field_id=weather_input.field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    # Fetch weather from API
    weather_data = get_weather_data(field.location_latitude, field.location_longitude)
    if not weather_data:
        raise HTTPException(status_code=500, detail="Failed to fetch weather data")
    
    # Add field_id and save to DB
    weather_data["field_id"] = weather_input.field_id
    return crud.create_weather_data(db=db, weather_data=weather_data)

@router.get("/weather/latest/{field_id}", response_model=WeatherDataOut)
def get_latest_weather(
    field_id: int,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get latest weather data for a field"""
    field = crud.get_field(db=db, field_id=field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    weather = crud.get_latest_weather(db=db, field_id=field_id)
    if not weather:
        raise HTTPException(status_code=404, detail="No weather data found")
    
    return weather

@router.get("/weather/history/{field_id}", response_model=list[WeatherDataOut])
def get_weather_history(
    field_id: int,
    days: int = 7,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get weather history for a field (last N days)"""
    field = crud.get_field(db=db, field_id=field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    return crud.get_weather_history(db=db, field_id=field_id, days=days)
