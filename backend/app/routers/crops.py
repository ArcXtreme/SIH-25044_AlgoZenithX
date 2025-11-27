from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.database import get_db
from backend.app.schemas.crop import FieldCreate, FieldOut, PredictionInput, PredictionOutput
from backend.app.routers.auth import get_current_user
from backend.app import crud

router = APIRouter()

# ===== FIELD ENDPOINTS =====
@router.post("/fields", response_model=FieldOut)
def create_field(
    field: FieldCreate, 
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Create a new field for the logged-in farmer"""
    return crud.create_field(db=db, field=field, user_id=current_user.id)

@router.get("/fields", response_model=list[FieldOut])
def get_my_fields(
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get all fields for the logged-in farmer"""
    return crud.get_user_fields(db=db, user_id=current_user.id)

@router.get("/fields/{field_id}", response_model=FieldOut)
def get_field_detail(
    field_id: int,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get details of a specific field"""
    field = crud.get_field(db=db, field_id=field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Field not found")
    return field

# ===== PREDICTION ENDPOINTS =====
@router.post("/predict", response_model=PredictionOutput)
def predict_yield(
    prediction_input: PredictionInput,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get crop yield prediction and recommendations"""
    # Verify field belongs to current user
    field = crud.get_field(db=db, field_id=prediction_input.field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    # TODO: Call ML model here to get real predictions
    # For now, return mock predictions
    mock_prediction_data = {
        "field_id": prediction_input.field_id,
        "crop_type": prediction_input.crop_type,
        "predicted_yield": 45.2,  # Mock: quintals/hectare
        "confidence_score": 0.87,
        "irrigation_recommendation": "Water every 7 days, 5cm depth",
        "fertilizer_recommendation": "NPK 20:20:20, 150kg/hectare at planting, 50kg/hectare at 45 days",
        "pest_recommendation": "Monitor for Brown Planthopper; use neem spray if needed"
    }
    
    return crud.create_prediction(db=db, prediction_data=mock_prediction_data)

@router.get("/predictions/{field_id}", response_model=list[PredictionOutput])
def get_field_predictions(
    field_id: int,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get all predictions for a field"""
    field = crud.get_field(db=db, field_id=field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    return crud.get_field_predictions(db=db, field_id=field_id)
