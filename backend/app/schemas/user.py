from pydantic import BaseModel, EmailStr

# schema for receiving data (Sign Up)
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    full_name: str

# schema for returning data (Response)
# We don't want to return the password!
class UserOut(BaseModel):
    id: int
    email: EmailStr
    full_name: str
    is_active: bool

    class Config:
        from_attributes = True

# NEW: schema for JWT Token
class Token(BaseModel):
    access_token: str
    token_type: str
