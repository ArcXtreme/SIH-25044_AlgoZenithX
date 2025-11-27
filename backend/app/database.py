from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 1. Define the database URL. 
# "sqlite:///./sql_app.db" means "create a file named sql_app.db in the current folder"
SQLALCHEMY_DATABASE_URL = "sqlite:///./sql_app.db"

# 2. Create the engine. 
# connect_args={"check_same_thread": False} is needed ONLY for SQLite.
engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)

# 3. Create a SessionLocal class.
# Each instance of this class will be a database session.
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 4. Create a Base class.
# We will inherit from this class to create our database models (like User).
Base = declarative_base()

# 5. Dependency to get the DB session in other files
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
