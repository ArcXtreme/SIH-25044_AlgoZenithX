from sqlalchemy import Column, Integer, String, Boolean
from backend.app.database import Base

class User(Base):
    __tablename__ = "users"  # This will be the table name in the DB

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    full_name = Column(String)
    is_active = Column(Boolean, default=True)
