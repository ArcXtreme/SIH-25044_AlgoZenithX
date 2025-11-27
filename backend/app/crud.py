from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from backend.app.models.user import User
from backend.app.models.crop import Field, Prediction
from backend.app.schemas.user import UserCreate
from backend.app.schemas.crop import FieldCreate, PredictionInput
from backend.app.utils.security import hash_password

# ===== USER FUNCTIONS =====
def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

def create_user(db: Session, user: UserCreate):
    hashed_password = hash_password(user.password)
    db_user = User(
        email=user.email, 
        hashed_password=hashed_password, 
        full_name=user.full_name
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# ===== FIELD FUNCTIONS =====
def create_field(db: Session, field: FieldCreate, user_id: int):
    db_field = Field(
        **field.dict(),
        user_id=user_id
    )
    db.add(db_field)
    db.commit()
    db.refresh(db_field)
    return db_field

def get_field(db: Session, field_id: int):
    return db.query(Field).filter(Field.id == field_id).first()

def get_user_fields(db: Session, user_id: int):
    return db.query(Field).filter(Field.user_id == user_id).all()

# ===== PREDICTION FUNCTIONS =====
def create_prediction(db: Session, prediction_data: dict):
    db_prediction = Prediction(**prediction_data)
    db.add(db_prediction)
    db.commit()
    db.refresh(db_prediction)
    return db_prediction

def get_field_predictions(db: Session, field_id: int):
    return db.query(Prediction).filter(Prediction.field_id == field_id).all()

# ===== WEATHER FUNCTIONS =====
def create_weather_data(db: Session, weather_data: dict):
    from backend.app.models.weather import WeatherData
    db_weather = WeatherData(**weather_data)
    db.add(db_weather)
    db.commit()
    db.refresh(db_weather)
    return db_weather

def get_latest_weather(db: Session, field_id: int):
    from backend.app.models.weather import WeatherData
    return db.query(WeatherData).filter(
        WeatherData.field_id == field_id
    ).order_by(WeatherData.fetched_at.desc()).first()

def get_weather_history(db: Session, field_id: int, days: int = 7):
    from backend.app.models.weather import WeatherData
    cutoff_date = datetime.utcnow() - timedelta(days=days)
    return db.query(WeatherData).filter(
        WeatherData.field_id == field_id,
        WeatherData.fetched_at >= cutoff_date
    ).order_by(WeatherData.fetched_at.desc()).all()

# ===== SOIL FUNCTIONS =====
def create_soil_data(db: Session, soil_data: dict):
    from backend.app.models.soil import SoilData
    db_soil = SoilData(**soil_data)
    db.add(db_soil)
    db.commit()
    db.refresh(db_soil)
    return db_soil

def get_latest_soil(db: Session, field_id: int):
    from backend.app.models.soil import SoilData
    return db.query(SoilData).filter(
        SoilData.field_id == field_id
    ).order_by(SoilData.fetched_at.desc()).first()

def get_soil_history(db: Session, field_id: int, days: int = 30):
    from backend.app.models.soil import SoilData
    cutoff_date = datetime.utcnow() - timedelta(days=days)
    return db.query(SoilData).filter(
        SoilData.field_id == field_id,
        SoilData.fetched_at >= cutoff_date
    ).order_by(SoilData.fetched_at.desc()).all()
