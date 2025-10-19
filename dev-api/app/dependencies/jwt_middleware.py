"""JWT Middleware Authentication Dependencies.

Provides FastAPI dependencies that work with the JWT authentication middleware
to extract authenticated developer information from request state.
"""

from typing import Optional

from fastapi import Depends, HTTPException, Request, status

from app.models.developer import Developer


def get_authenticated_developer(request: Request) -> Developer:
    """
    Get the authenticated developer from request state (set by JWT middleware).
    
    This dependency should be used in protected routes that require authentication.
    The JWT middleware automatically validates tokens and populates request.state.developer.
    
    Args:
        request: FastAPI request object with auth state from middleware
        
    Returns:
        Authenticated developer object
        
    Raises:
        HTTPException: If no authenticated developer found in request state
    """
    if not hasattr(request.state, "developer") or not request.state.developer:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required",
            headers={"WWW-Authenticate": "Bearer"}
        )
    
    return request.state.developer


def get_authenticated_developer_optional(request: Request) -> Optional[Developer]:
    """
    Get the authenticated developer from request state, returning None if not authenticated.
    
    This dependency can be used in routes that optionally require authentication.
    
    Args:
        request: FastAPI request object with auth state from middleware
        
    Returns:
        Authenticated developer object or None if not authenticated
    """
    if not hasattr(request.state, "developer"):
        return None
    
    return request.state.developer


def get_developer_id(request: Request) -> str:
    """
    Get the authenticated developer ID from request state.
    
    Args:
        request: FastAPI request object with auth state from middleware
        
    Returns:
        Developer ID string
        
    Raises:
        HTTPException: If no authenticated developer found
    """
    if not hasattr(request.state, "developer_id") or not request.state.developer_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required",
            headers={"WWW-Authenticate": "Bearer"}
        )
    
    return request.state.developer_id


def get_auth_data(request: Request) -> dict:
    """
    Get the full authentication data from request state.
    
    Returns the complete auth data dict including developer info, token payload, etc.
    
    Args:
        request: FastAPI request object with auth state from middleware
        
    Returns:
        Authentication data dictionary
        
    Raises:
        HTTPException: If no authentication data found
    """
    if not hasattr(request.state, "auth") or not request.state.auth:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required",
            headers={"WWW-Authenticate": "Bearer"}
        )
    
    return request.state.auth


# Convenience dependency aliases for common use cases
CurrentDeveloper = Depends(get_authenticated_developer)
CurrentDeveloperOptional = Depends(get_authenticated_developer_optional)
CurrentDeveloperId = Depends(get_developer_id)
AuthData = Depends(get_auth_data)