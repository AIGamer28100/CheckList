"""Consent models for OAuth-like authorization flow."""

from datetime import datetime, timezone
from enum import Enum
from typing import List, Optional

from pydantic import BaseModel, Field


class ConsentStatus(str, Enum):
    """Consent status enumeration."""
    PENDING = "pending"
    GRANTED = "granted"
    DENIED = "denied"
    REVOKED = "revoked"


class ConsentScope(str, Enum):
    """Available consent scopes."""
    READ_TASKS = "read:tasks"
    WRITE_TASKS = "write:tasks"
    DELETE_TASKS = "delete:tasks"
    READ_PROFILE = "read:profile"
    WRITE_PROFILE = "write:profile"


class ConsentRequest(BaseModel):
    """OAuth-like consent request model."""
    id: str = Field(..., description="Unique consent request ID")
    client_id: str = Field(..., description="Client application ID")
    client_name: str = Field(..., description="Human-readable client name")
    client_description: Optional[str] = Field(None, description="Client description")
    client_logo_url: Optional[str] = Field(None, description="Client logo URL")
    developer_id: str = Field(..., description="Developer ID who needs to grant consent")
    scopes: List[ConsentScope] = Field(..., description="Requested scopes/permissions")
    redirect_uri: str = Field(..., description="URI to redirect after consent")
    state: Optional[str] = Field(None, description="State parameter for CSRF protection")
    status: ConsentStatus = Field(default=ConsentStatus.PENDING, description="Consent status")
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    expires_at: datetime = Field(..., description="When this consent request expires")
    granted_at: Optional[datetime] = Field(None, description="When consent was granted")
    granted_scopes: Optional[List[ConsentScope]] = Field(None, description="Actually granted scopes")


class ConsentRequestCreate(BaseModel):
    """Model for creating a new consent request."""
    client_id: str = Field(..., description="Client application ID")
    client_name: str = Field(..., description="Human-readable client name")
    client_description: Optional[str] = Field(None, description="Client description")
    client_logo_url: Optional[str] = Field(None, description="Client logo URL")
    scopes: List[ConsentScope] = Field(..., description="Requested scopes/permissions")
    redirect_uri: str = Field(..., description="URI to redirect after consent")
    state: Optional[str] = Field(None, description="State parameter for CSRF protection")
    expires_minutes: int = Field(default=60, description="Consent request expiration in minutes")


class ConsentResponse(BaseModel):
    """Model for developer's consent response."""
    consent_id: str = Field(..., description="Consent request ID")
    granted: bool = Field(..., description="Whether consent is granted")
    granted_scopes: Optional[List[ConsentScope]] = Field(None, description="Scopes to grant (if granted=True)")


class ConsentGrant(BaseModel):
    """Persisted consent grant for a client."""
    id: str = Field(..., description="Unique grant ID")
    developer_id: str = Field(..., description="Developer who granted consent")
    client_id: str = Field(..., description="Client application ID")
    client_name: str = Field(..., description="Human-readable client name")
    scopes: List[ConsentScope] = Field(..., description="Granted scopes")
    granted_at: datetime = Field(..., description="When consent was granted")
    last_used: Optional[datetime] = Field(None, description="Last time this grant was used")
    is_active: bool = Field(default=True, description="Whether this grant is still active")


class ConsentGrantCreate(BaseModel):
    """Model for creating a consent grant."""
    developer_id: str
    client_id: str
    client_name: str
    scopes: List[ConsentScope]


# Response models for API
class ConsentRequestResponse(BaseModel):
    """API response model for consent requests."""
    id: str
    client_id: str
    client_name: str
    client_description: Optional[str]
    client_logo_url: Optional[str]
    scopes: List[ConsentScope]
    redirect_uri: str
    state: Optional[str]
    status: ConsentStatus
    created_at: datetime
    expires_at: datetime


class ConsentGrantResponse(BaseModel):
    """API response model for consent grants."""
    id: str
    client_id: str
    client_name: str
    scopes: List[ConsentScope]
    granted_at: datetime
    last_used: Optional[datetime]
    is_active: bool


class ConsentGrantListResponse(BaseModel):
    """API response model for list of consent grants."""
    grants: List[ConsentGrantResponse]
    total: int