from fastapi import FastAPI
from backend.app.database import engine, Base
from backend.app.models import user, crop  # Import both models
from backend.app.routers import auth, crops  # Import crops router

# Create the database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="SIH Crop Yield Prediction API",
    version="1.0"
)

# Register routers
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(crops.router, prefix="/api", tags=["Crops & Predictions"])

@app.get("/")
def root():
    return {"message": "Database created and App is running!"}
