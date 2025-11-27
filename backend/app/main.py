from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.app.database import engine, Base
from backend.app.models import user, crop, weather, soil
from backend.app.routers import auth, crops, weather as weather_router, soil as soil_router, analytics

# Create the database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="SIH Crop Yield Prediction API",
    version="1.0",
    description="AI-Powered Crop Yield Prediction and Optimization for Indian Farmers"
)

# Enable CORS for frontend integration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change to specific frontend URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(crops.router, prefix="/api", tags=["Crops & Predictions"])
app.include_router(weather_router.router, prefix="/api", tags=["Weather"])
app.include_router(soil_router.router, prefix="/api", tags=["Soil"])
app.include_router(analytics.router, prefix="/api", tags=["Analytics"])

@app.get("/")
def root():
    return {
        "message": "SIH Crop Yield Prediction API is running",
        "version": "1.0",
        "docs": "/docs",
        "health": "ok"
    }

@app.get("/health")
def health_check():
    return {"status": "healthy"}
