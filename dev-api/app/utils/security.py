"""Security utilities for authentication and API key management."""

import secrets
import string
from datetime import datetime, timedelta, timezone
from typing import Optional

import bcrypt
from jose import JWTError, jwt
from passlib.context import CryptContext

from app.config import settings


# Password hashing context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    """Hash a password using bcrypt."""
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against its hash."""
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    """Alias for hash_password for compatibility."""
    return hash_password(password)


def generate_verification_token(email: str) -> str:
    """Generate a verification token for email verification."""
    data = {
        "email": email,
        "type": "verification",
        "exp": datetime.now(timezone.utc) + timedelta(hours=24)  # 24 hour expiry
    }
    return jwt.encode(data, settings.secret_key, algorithm=settings.algorithm)


def generate_api_key(prefix: Optional[str] = None, length: int = 32) -> str:
    """
    Generate a secure API key.
    
    Args:
        prefix: Optional prefix for the API key
        length: Length of the random part (default 32)
    
    Returns:
        Generated API key
    """
    if prefix is None:
        prefix = settings.api_key_prefix or "ck_"
    
    # Generate secure random string
    alphabet = string.ascii_letters + string.digits
    random_part = ''.join(secrets.choice(alphabet) for _ in range(length))
    
    return f"{prefix}{random_part}"


def generate_otp() -> str:
    """Generate a 6-digit OTP."""
    return ''.join(secrets.choice(string.digits) for _ in range(6))


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """
    Create a JWT access token.
    
    Args:
        data: Data to encode in the token
        expires_delta: Token expiration time
    
    Returns:
        Encoded JWT token
    """
    to_encode = data.copy()
    
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.access_token_expire_minutes)
    
    to_encode.update({"exp": expire})
    
    return jwt.encode(to_encode, settings.secret_key, algorithm=settings.algorithm)


def create_refresh_token(data: dict) -> str:
    """
    Create a JWT refresh token.
    
    Args:
        data: Data to encode in the token
    
    Returns:
        Encoded JWT refresh token
    """
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(days=settings.refresh_token_expire_days)
    to_encode.update({"exp": expire, "type": "refresh"})
    
    return jwt.encode(to_encode, settings.secret_key, algorithm=settings.algorithm)


def verify_token(token: str) -> Optional[dict]:
    """
    Verify and decode a JWT token.
    
    Args:
        token: JWT token to verify
    
    Returns:
        Decoded token payload or None if invalid
    """
    try:
        payload = jwt.decode(token, settings.secret_key, algorithms=[settings.algorithm])
        return payload
    except JWTError:
        return None


def hash_api_key(api_key: str) -> str:
    """
    Hash an API key for secure storage.
    
    Args:
        api_key: Raw API key
    
    Returns:
        Hashed API key
    """
    return bcrypt.hashpw(api_key.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')


def verify_api_key(api_key: str, hashed_key: str) -> bool:
    """
    Verify an API key against its hash.
    
    Args:
        api_key: Raw API key
        hashed_key: Hashed API key
    
    Returns:
        True if valid, False otherwise
    """
    return bcrypt.checkpw(api_key.encode('utf-8'), hashed_key.encode('utf-8'))


def extract_api_key_from_header(authorization: str) -> Optional[str]:
    """
    Extract API key from Authorization header.
    
    Args:
        authorization: Authorization header value
    
    Returns:
        API key or None if not found
    """
    if not authorization:
        return None
    
    # Support both "Bearer <key>" and "ApiKey <key>" formats
    parts = authorization.split()
    if len(parts) != 2:
        return None
    
    scheme, key = parts
    if scheme.lower() not in ["bearer", "apikey"]:
        return None
    
    return key


def mask_api_key(api_key: str, visible_chars: int = 4) -> str:
    """
    Mask an API key for display purposes.
    
    Args:
        api_key: API key to mask
        visible_chars: Number of characters to show at the end
    
    Returns:
        Masked API key
    """
    if len(api_key) <= visible_chars:
        return "*" * len(api_key)
    
    visible_part = api_key[-visible_chars:]
    masked_part = "*" * (len(api_key) - visible_chars)
    
    return f"{masked_part}{visible_part}"


def is_strong_password(password: str) -> tuple[bool, list[str]]:
    """
    Check if a password meets security requirements.
    
    Args:
        password: Password to check
    
    Returns:
        Tuple of (is_valid, list_of_errors)
    """
    errors = []
    
    if len(password) < 8:
        errors.append("Password must be at least 8 characters long")
    
    if not any(c.isupper() for c in password):
        errors.append("Password must contain at least one uppercase letter")
    
    if not any(c.islower() for c in password):
        errors.append("Password must contain at least one lowercase letter")
    
    if not any(c.isdigit() for c in password):
        errors.append("Password must contain at least one number")
    
    special_chars = "!@#$%^&*()_+-=[]{}|;:,.<>?"
    if not any(c in special_chars for c in password):
        errors.append("Password must contain at least one special character")
    
    return len(errors) == 0, errors