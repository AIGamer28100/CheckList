"""User-related Pydantic models."""

from datetime import datetime
from typing import Dict, List, Optional

from pydantic import BaseModel, EmailStr, Field, ConfigDict


class UserBase(BaseModel):
    """Base user model with common fields."""
    model_config = ConfigDict(from_attributes=True)
    
    email: EmailStr = Field(..., description="User email address")
    full_name: Optional[str] = Field(None, max_length=100, description="User full name")
    is_active: bool = Field(default=True, description="Whether user account is active")
    avatar_url: Optional[str] = Field(None, description="User avatar URL")
    timezone: Optional[str] = Field(None, description="User timezone")
    preferences: Dict[str, str] = Field(default_factory=dict, description="User preferences")


class UserCreate(UserBase):
    """Model for creating a new user."""
    password: str = Field(..., min_length=8, max_length=100, description="User password")


class UserUpdate(BaseModel):
    """Model for updating an existing user."""
    model_config = ConfigDict(from_attributes=True)
    
    email: Optional[EmailStr] = None
    full_name: Optional[str] = Field(None, max_length=100)
    is_active: Optional[bool] = None
    avatar_url: Optional[str] = None
    timezone: Optional[str] = None
    preferences: Optional[Dict[str, str]] = None


class UserResponse(UserBase):
    """Model for user responses."""
    id: str = Field(..., description="User ID")
    created_at: datetime = Field(..., description="User creation timestamp")
    updated_at: Optional[datetime] = Field(None, description="Last update timestamp")
    last_login: Optional[datetime] = Field(None, description="Last login timestamp")


class UserProfileResponse(UserResponse):
    """Extended user profile response with statistics."""
    total_tasks: int = Field(default=0, description="Total number of tasks")
    completed_tasks: int = Field(default=0, description="Number of completed tasks")
    completion_rate: float = Field(default=0.0, description="Task completion rate")