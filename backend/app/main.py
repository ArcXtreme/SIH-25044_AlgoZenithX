from fastapi import FastAPI
from backend.app.database import engine, Base
from backend.app.models import user, crop, weather, soil  # Add soil
from backend.app.routers import auth, crops, weather as weather_router, soil as soil_router  # Add soil router

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="SIH Crop Yield Prediction API",
    version="1.0"
)

app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(crops.router, prefix="/api", tags=["Crops & Predictions"])
app.include_router(weather_router.router, prefix="/api", tags=["Weather"])
app.include_router(soil_router.router, prefix="/api", tags=["Soil"])  # NEW

@app.get("/")
def root():
    return {"message": "Database created and App is running!"}
