from sqlalchemy.orm import Session
from backend.app.models.user import User
from backend.app.models.crop import Field, Prediction
from backend.app.schemas.user import UserCreate
from backend.app.schemas.crop import FieldCreate, PredictionInput
from backend.app.utils.security import hash_password

# ===== USER FUNCTIONS (existing) =====
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

# ===== FIELD FUNCTIONS (new) =====
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

# ===== PREDICTION FUNCTIONS (new) =====
def create_prediction(db: Session, prediction_data: dict):
    db_prediction = Prediction(**prediction_data)
    db.add(db_prediction)
    db.commit()
    db.refresh(db_prediction)
    return db_prediction

def get_field_predictions(db: Session, field_id: int):
    return db.query(Prediction).filter(Prediction.field_id == field_id).all()
