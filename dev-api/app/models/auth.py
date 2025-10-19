"""Authentication-related Pydantic models."""

from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr, Field, ConfigDict


class Token(BaseModel):
    """JWT token response model."""
    model_config = ConfigDict(from_attributes=True)
    
    access_token: str = Field(..., description="JWT access token")
    refresh_token: str = Field(..., description="JWT refresh token")
    token_type: str = Field(default="bearer", description="Token type")
    expires_in: int = Field(..., description="Token expiration time in seconds")


class TokenData(BaseModel):
    """Token payload data."""
    model_config = ConfigDict(from_attributes=True)
    
    user_id: Optional[str] = None
    email: Optional[str] = None
    exp: Optional[datetime] = None


class LoginRequest(BaseModel):
    """User login request model."""
    model_config = ConfigDict(from_attributes=True)
    
    email: EmailStr = Field(..., description="User email address")
    password: str = Field(..., min_length=1, description="User password")


class RegisterRequest(BaseModel):
    """User registration request model."""
    model_config = ConfigDict(from_attributes=True)
    
    email: EmailStr = Field(..., description="User email address")
    password: str = Field(..., min_length=8, max_length=100, description="User password")
    full_name: Optional[str] = Field(None, max_length=100, description="User full name")


class PasswordChangeRequest(BaseModel):
    """Password change request model."""
    model_config = ConfigDict(from_attributes=True)
    
    current_password: str = Field(..., description="Current password")
    new_password: str = Field(..., min_length=8, max_length=100, description="New password")


class PasswordResetRequest(BaseModel):
    """Password reset request model."""
    model_config = ConfigDict(from_attributes=True)
    
    email: EmailStr = Field(..., description="User email address")


class RefreshTokenRequest(BaseModel):
    """Refresh token request model."""
    model_config = ConfigDict(from_attributes=True)
    
    refresh_token: str = Field(..., description="Refresh token")