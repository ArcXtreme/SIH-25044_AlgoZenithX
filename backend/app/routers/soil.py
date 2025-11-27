from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend.app.database import get_db
from backend.app.schemas.soil import SoilDataOut, SoilInput
from backend.app.routers.auth import get_current_user
from backend.app.services.soil_service import get_soil_data
from backend.app import crud

router = APIRouter()

@router.post("/soil/fetch", response_model=SoilDataOut)
def fetch_soil(
    soil_input: SoilInput,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Fetch soil data for a field"""
    field = crud.get_field(db=db, field_id=soil_input.field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    soil_data = get_soil_data(field.location_latitude, field.location_longitude)
    soil_data["field_id"] = soil_input.field_id
    
    return crud.create_soil_data(db=db, soil_data=soil_data)

@router.get("/soil/latest/{field_id}", response_model=SoilDataOut)
def get_latest_soil(
    field_id: int,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get latest soil data for a field"""
    field = crud.get_field(db=db, field_id=field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    soil = crud.get_latest_soil(db=db, field_id=field_id)
    if not soil:
        raise HTTPException(status_code=404, detail="No soil data found")
    
    return soil

@router.get("/soil/history/{field_id}", response_model=list[SoilDataOut])
def get_soil_history(
    field_id: int,
    days: int = 30,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get soil history for a field (last N days)"""
    field = crud.get_field(db=db, field_id=field_id)
    if not field or field.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Unauthorized access to field")
    
    return crud.get_soil_history(db=db, field_id=field_id, days=days)
