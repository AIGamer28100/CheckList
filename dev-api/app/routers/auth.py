"""Authentication router for developer platform."""

from datetime import datetime, timezone, timedelta
from typing import Dict, Optional
import logging

from fastapi import APIRouter, Depends, HTTPException, Query, Request
from fastapi.responses import RedirectResponse
from pydantic import BaseModel, EmailStr

from app.models.developer import Developer, DeveloperCreate, DeveloperUpdate
from app.services.email_service import email_service
from app.services.firestore_service import firestore_service
from app.services.google_oauth_service import google_oauth_service
from app.utils.security import (
    create_access_token,
    generate_otp,
    generate_verification_token,
    verify_password,
    get_password_hash
)

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/auth", tags=["Authentication"])


# Pydantic models for requests/responses
class EmailLoginRequest(BaseModel):
    """Request model for email/password login."""
    email: EmailStr
    password: str


class EmailRegisterRequest(BaseModel):
    """Request model for email registration."""
    email: EmailStr
    password: str
    name: str
    company: Optional[str] = None
    website: Optional[str] = None


class OTPVerificationRequest(BaseModel):
    """Request model for OTP verification."""
    email: EmailStr
    otp: str


class ResendOTPRequest(BaseModel):
    """Request model for resending OTP."""
    email: EmailStr


class AuthResponse(BaseModel):
    """Response model for successful authentication."""
    access_token: str
    token_type: str = "bearer"
    developer_id: str
    email: str
    name: str
    email_verified: bool


class MessageResponse(BaseModel):
    """Response model for messages."""
    message: str


# OAuth endpoints
@router.get("/google/login")
async def google_login(request: Request, redirect_url: Optional[str] = Query(None)):
    """
    Initiate Google OAuth login.
    
    Args:
        redirect_url: Optional URL to redirect after successful authentication
    
    Returns:
        Redirect to Google OAuth authorization URL
    """
    if not google_oauth_service.is_configured():
        raise HTTPException(
            status_code=503, 
            detail="Google OAuth is not configured"
        )
    
    # Generate state for CSRF protection
    state = generate_otp()  # Reuse OTP generation for random state
    
    # Store state and redirect URL in session (in production, use Redis or similar)
    # For now, we'll pass redirect_url in state
    if redirect_url:
        state = f"{state}:{redirect_url}"
    
    auth_url = google_oauth_service.get_auth_url(state=state)
    if not auth_url:
        raise HTTPException(
            status_code=500, 
            detail="Failed to generate authorization URL"
        )
    
    return RedirectResponse(url=auth_url)


@router.get("/google/callback")
async def google_callback(
    request: Request,
    code: Optional[str] = Query(None),
    state: Optional[str] = Query(None),
    error: Optional[str] = Query(None)
):
    """
    Handle Google OAuth callback.
    
    Args:
        code: Authorization code from Google
        state: State parameter for CSRF protection
        error: Error parameter if OAuth failed
    
    Returns:
        Redirect to frontend with authentication result
    """
    if error:
        # Handle OAuth error
        error_message = f"OAuth error: {error}"
        return RedirectResponse(
            url=f"/developer-portal?error={error_message}", 
            status_code=302
        )
    
    if not code:
        return RedirectResponse(
            url="/developer-portal?error=No authorization code received", 
            status_code=302
        )
    
    # Authenticate developer
    developer_id, auth_error = await google_oauth_service.authenticate_developer(code, state)
    
    if auth_error or not developer_id:
        return RedirectResponse(
            url=f"/developer-portal?error={auth_error or 'Authentication failed'}", 
            status_code=302
        )
    
    # Get developer details
    developer = await firestore_service.get_developer_by_id(developer_id)
    if not developer:
        return RedirectResponse(
            url="/developer-portal?error=Developer account not found", 
            status_code=302
        )
    
    # Generate access token
    access_token = create_access_token(data={"sub": developer_id})
    
    # Extract redirect URL from state if present
    redirect_url = "/developer-portal"
    if state and ":" in state:
        parts = state.split(":", 1)
        if len(parts) == 2:
            redirect_url = parts[1]
    
    # Redirect to frontend with token
    return RedirectResponse(
        url=f"{redirect_url}?token={access_token}&success=Login successful", 
        status_code=302
    )


# Email/Password authentication
@router.post("/register", response_model=MessageResponse)
async def register_with_email(request: EmailRegisterRequest):
    """
    Register new developer with email and password.
    
    Args:
        request: Registration request data
    
    Returns:
        Success message indicating verification email sent
    """
    # Check if developer already exists
    existing_developer = await firestore_service.get_developer_by_email(request.email)
    if existing_developer:
        raise HTTPException(
            status_code=400, 
            detail="Developer with this email already exists"
        )
    
    # Generate verification token and OTP
    verification_token, expires_at = generate_verification_token()
    otp = generate_otp()
    
    # Create developer account
    developer_data = DeveloperCreate(
        email=request.email,
        name=request.name,
        company=request.company,
        website=request.website,
        password_hash=get_password_hash(request.password),
        verification_token=verification_token,
        verification_token_expires=expires_at,
        otp=otp,
        otp_expires=datetime.now(timezone.utc).replace(microsecond=0) + timedelta(minutes=10)
    )
    
    developer = await firestore_service.create_developer(developer_data)
    if not developer:
        raise HTTPException(
            status_code=500, 
            detail="Failed to create developer account"
        )
    
    # Send verification email
    email_sent = await email_service.send_otp_email(
        request.email, 
        otp, 
        request.name
    )
    
    if not email_sent:
        # Delete created developer if email failed
        # In production, you might want to implement a cleanup job
        logger.warning(f"Failed to send verification email to {request.email}")
    
    return MessageResponse(
        message="Registration successful. Please check your email for verification code."
    )


@router.post("/verify-email", response_model=AuthResponse)
async def verify_email(request: OTPVerificationRequest):
    """
    Verify email address using OTP.
    
    Args:
        request: OTP verification request
    
    Returns:
        Authentication response with access token
    """
    # Get developer by email
    developer = await firestore_service.get_developer_by_email(request.email)
    if not developer:
        raise HTTPException(
            status_code=404, 
            detail="Developer account not found"
        )
    
    # Check if already verified
    if developer.email_verified:
        raise HTTPException(
            status_code=400, 
            detail="Email already verified"
        )
    
    # Verify OTP
    if not developer.otp or developer.otp != request.otp:
        raise HTTPException(
            status_code=400, 
            detail="Invalid verification code"
        )
    
    # Check OTP expiration
    if developer.otp_expires and developer.otp_expires < datetime.now(timezone.utc):
        raise HTTPException(
            status_code=400, 
            detail="Verification code has expired"
        )
    
    # Mark email as verified
    verified = await firestore_service.verify_developer_email(developer.id)
    if not verified:
        raise HTTPException(
            status_code=500, 
            detail="Failed to verify email"
        )
    
    # Generate access token
    access_token = create_access_token(data={"sub": developer.id})
    
    return AuthResponse(
        access_token=access_token,
        developer_id=developer.id,
        email=developer.email,
        name=developer.name,
        email_verified=True
    )


@router.post("/login", response_model=AuthResponse)
async def login_with_email(request: EmailLoginRequest):
    """
    Login with email and password.
    
    Args:
        request: Login request data
    
    Returns:
        Authentication response with access token
    """
    # Get developer by email
    developer = await firestore_service.get_developer_by_email(request.email)
    if not developer:
        raise HTTPException(
            status_code=401, 
            detail="Invalid email or password"
        )
    
    # Verify password
    if not developer.password_hash or not verify_password(request.password, developer.password_hash):
        raise HTTPException(
            status_code=401, 
            detail="Invalid email or password"
        )
    
    # Check if email is verified
    if not developer.email_verified:
        raise HTTPException(
            status_code=403, 
            detail="Email not verified. Please verify your email before logging in."
        )
    
    # Check if account is active
    if not developer.is_active:
        raise HTTPException(
            status_code=403, 
            detail="Account is deactivated. Please contact support."
        )
    
    # Update last login
    update_data = DeveloperUpdate(last_login=datetime.now(timezone.utc))
    await firestore_service.update_developer(developer.id, update_data)
    
    # Generate access token
    access_token = create_access_token(data={"sub": developer.id})
    
    return AuthResponse(
        access_token=access_token,
        developer_id=developer.id,
        email=developer.email,
        name=developer.name,
        email_verified=developer.email_verified
    )


@router.post("/resend-otp", response_model=MessageResponse)
async def resend_otp(request: ResendOTPRequest):
    """
    Resend OTP for email verification.
    
    Args:
        request: Resend OTP request
    
    Returns:
        Success message
    """
    # Get developer by email
    developer = await firestore_service.get_developer_by_email(request.email)
    if not developer:
        raise HTTPException(
            status_code=404, 
            detail="Developer account not found"
        )
    
    # Check if already verified
    if developer.email_verified:
        raise HTTPException(
            status_code=400, 
            detail="Email already verified"
        )
    
    # Generate new OTP
    otp = generate_otp()
    
    # Update developer with new OTP
    update_data = DeveloperUpdate(
        otp=otp,
        otp_expires=datetime.now(timezone.utc).replace(microsecond=0) + timedelta(minutes=10)
    )
    
    updated_developer = await firestore_service.update_developer(developer.id, update_data)
    if not updated_developer:
        raise HTTPException(
            status_code=500, 
            detail="Failed to generate new verification code"
        )
    
    # Send new OTP email
    email_sent = await email_service.send_otp_email(
        request.email, 
        otp, 
        developer.name
    )
    
    if not email_sent:
        raise HTTPException(
            status_code=500, 
            detail="Failed to send verification email"
        )
    
    return MessageResponse(
        message="New verification code sent to your email"
    )


# Health check
@router.get("/health")
async def auth_health():
    """Health check for authentication service."""
    return {
        "status": "healthy",
        "google_oauth_configured": google_oauth_service.is_configured(),
        "timestamp": datetime.now(timezone.utc).isoformat()
    }