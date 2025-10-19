"""Authentication dependencies for FastAPI."""

from typing import Optional

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError, jwt

from app.config import settings
from app.models.developer import Developer
from app.services.firestore_service import firestore_service

# OAuth2 scheme for bearer token
security = HTTPBearer()


async def get_current_developer(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> Developer:
    """
    Get the current authenticated developer from JWT token.
    
    Args:
        credentials: HTTP Authorization credentials containing JWT token
    
    Returns:
        Current authenticated developer
    
    Raises:
        HTTPException: If token is invalid or developer not found
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        # Decode JWT token
        payload = jwt.decode(
            credentials.credentials, 
            settings.secret_key, 
            algorithms=[settings.algorithm]
        )
        
        # Extract developer ID from token
        developer_id = payload.get("sub")
        if developer_id is None:
            raise credentials_exception
            
    except JWTError:
        raise credentials_exception
    
    # Get developer from database
    developer = await firestore_service.get_developer_by_id(developer_id)
    if developer is None:
        raise credentials_exception
    
    # Check if developer account is active
    if not developer.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Developer account is deactivated"
        )
    
    # Check if email is verified
    if not developer.email_verified:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Email not verified. Please verify your email to access the API."
        )
    
    return developer


async def get_current_developer_optional(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(HTTPBearer(auto_error=False))
) -> Optional[Developer]:
    """
    Get the current authenticated developer, returning None if not authenticated.
    
    Args:
        credentials: Optional HTTP Authorization credentials
    
    Returns:
        Current authenticated developer or None
    """
    if not credentials:
        return None
    
    try:
        return await get_current_developer(credentials)
    except HTTPException:
        return None


async def verify_api_key(api_key: str) -> Optional[Developer]:
    """
    Verify API key and return associated developer.
    
    Args:
        api_key: API key to verify
    
    Returns:
        Developer associated with the API key or None if invalid
    """
    if not api_key:
        return None
    
    try:
        # Hash the provided API key
        from app.utils.security import hash_api_key
        key_hash = hash_api_key(api_key)
        
        # Find API key in database
        api_key_obj = await firestore_service.get_api_key_by_hash(key_hash)
        if not api_key_obj:
            return None
        
        # Check if API key is active
        if not api_key_obj.is_active:
            return None
        
        # Check if API key has expired
        from datetime import datetime, timezone
        if api_key_obj.expires_at and api_key_obj.expires_at < datetime.now(timezone.utc):
            return None
        
        # Get associated developer
        developer = await firestore_service.get_developer_by_id(api_key_obj.developer_id)
        if not developer or not developer.is_active:
            return None
        
        # Update API key usage
        await firestore_service.update_api_key_usage(api_key_obj.id)
        
        return developer
        
    except Exception:
        return None


class APIKeyAuth:
    """API Key authentication dependency."""
    
    def __init__(self, required: bool = True):
        """
        Initialize API key authentication.
        
        Args:
            required: Whether API key is required (raises exception if missing)
        """
        self.required = required
    
    async def __call__(self, api_key: Optional[str] = None) -> Optional[Developer]:
        """
        Authenticate request using API key.
        
        Args:
            api_key: API key from request header or query parameter
        
        Returns:
            Developer associated with API key
        
        Raises:
            HTTPException: If API key is required but invalid/missing
        """
        if not api_key:
            if self.required:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="API key required",
                    headers={"WWW-Authenticate": "ApiKey"}
                )
            return None
        
        developer = await verify_api_key(api_key)
        
        if not developer:
            if self.required:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid or expired API key",
                    headers={"WWW-Authenticate": "ApiKey"}
                )
            return None
        
        return developer


# Dependency instances
require_api_key = APIKeyAuth(required=True)
optional_api_key = APIKeyAuth(required=False)