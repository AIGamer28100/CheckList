"""JWT Authentication Middleware for FastAPI."""

import logging
from typing import Optional

from fastapi import Request, Response, status
from fastapi.responses import JSONResponse
from jose import JWTError, jwt
from starlette.middleware.base import BaseHTTPMiddleware

from app.config import settings
from app.services.firestore_service import firestore_service


logger = logging.getLogger(__name__)


class JWTAuthMiddleware(BaseHTTPMiddleware):
    """
    JWT Authentication Middleware.
    
    Automatically validates JWT tokens for protected routes and adds
    developer information to the request state.
    """
    
    def __init__(self, app, protected_paths: Optional[list[str]] = None):
        """
        Initialize JWT authentication middleware.
        
        Args:
            app: FastAPI application instance
            protected_paths: List of path prefixes that require authentication
                           If None, all paths except public ones are protected
        """
        super().__init__(app)
        
        # Default protected paths - API endpoints that require authentication
        self.protected_paths = protected_paths or [
            "/api/v1/tasks",
            "/api/v1/users",
            "/api/v1/analytics",
            "/portal/api",  # Developer portal API endpoints
        ]
        
        # Public paths that don't require authentication
        self.public_paths = [
            "/",
            "/health",
            "/docs",
            "/redoc",
            "/openapi.json",
            "/auth/login",
            "/auth/register", 
            "/auth/google/login",
            "/auth/google/callback",
            "/auth/verify-email",
            "/auth/resend-otp",
            "/auth/forgot-password",
            "/auth/reset-password",
            "/portal/login",
            "/portal/register",
            "/portal/auth",
            "/static",
            "/favicon.ico",
        ]
    
    def _is_protected_path(self, path: str) -> bool:
        """
        Check if a path requires authentication.
        
        Args:
            path: Request path
            
        Returns:
            True if path requires authentication
        """
        # Check if path is explicitly public
        for public_path in self.public_paths:
            if path.startswith(public_path):
                return False
        
        # Check if path matches protected patterns
        for protected_path in self.protected_paths:
            if path.startswith(protected_path):
                return True
        
        # Default behavior: protect API paths, allow others
        return path.startswith("/api/")
    
    def _extract_token_from_request(self, request: Request) -> Optional[str]:
        """
        Extract JWT token from request.
        
        Supports multiple token sources:
        1. Authorization header (Bearer token)
        2. Cookie (access_token)
        3. Query parameter (token)
        
        Args:
            request: FastAPI request object
            
        Returns:
            JWT token or None if not found
        """
        # 1. Check Authorization header
        authorization = request.headers.get("Authorization")
        if authorization and authorization.startswith("Bearer "):
            return authorization.split(" ", 1)[1]
        
        # 2. Check cookie
        token = request.cookies.get("access_token")
        if token:
            return token
        
        # 3. Check query parameter
        token = request.query_params.get("token")
        if token:
            return token
        
        return None
    
    async def _validate_token(self, token: str) -> Optional[dict]:
        """
        Validate JWT token and return developer information.
        
        Args:
            token: JWT token to validate
            
        Returns:
            Developer information or None if invalid
        """
        try:
            # Decode JWT token
            payload = jwt.decode(
                token,
                settings.secret_key,
                algorithms=[settings.algorithm]
            )
            
            # Extract developer ID
            developer_id = payload.get("sub")
            if not developer_id:
                return None
            
            # Get developer from database
            developer = await firestore_service.get_developer_by_id(developer_id)
            if not developer:
                return None
            
            # Check if developer is active
            if not developer.is_active:
                logger.warning(f"Inactive developer attempted access: {developer_id}")
                return None
            
            # Check if email is verified for API access
            if not developer.email_verified:
                logger.warning(f"Unverified developer attempted access: {developer_id}")
                return None
            
            return {
                "developer_id": developer.id,
                "email": developer.email,
                "name": developer.name,
                "developer": developer,
                "token_payload": payload
            }
            
        except JWTError as e:
            logger.warning(f"JWT validation failed: {str(e)}")
            return None
        except Exception as e:
            logger.error(f"Unexpected error during token validation: {str(e)}")
            return None
    
    async def dispatch(self, request: Request, call_next):
        """
        Process the request and handle JWT authentication.
        
        Args:
            request: FastAPI request object
            call_next: Next middleware or endpoint
            
        Returns:
            Response from the application or authentication error
        """
        path = request.url.path
        method = request.method
        
        # Log request for debugging
        logger.debug(f"Processing request: {method} {path}")
        
        # Skip authentication for non-protected paths
        if not self._is_protected_path(path):
            logger.debug(f"Public path, skipping auth: {path}")
            return await call_next(request)
        
        # Extract token from request
        token = self._extract_token_from_request(request)
        
        if not token:
            logger.warning(f"No token found for protected path: {path}")
            return JSONResponse(
                status_code=status.HTTP_401_UNAUTHORIZED,
                content={
                    "detail": "Authentication required",
                    "error_code": "MISSING_TOKEN",
                    "message": "Access token is required for this endpoint"
                },
                headers={"WWW-Authenticate": "Bearer"}
            )
        
        # Validate token
        auth_data = await self._validate_token(token)
        
        if not auth_data:
            logger.warning(f"Invalid token for protected path: {path}")
            return JSONResponse(
                status_code=status.HTTP_401_UNAUTHORIZED,
                content={
                    "detail": "Invalid or expired token",
                    "error_code": "INVALID_TOKEN", 
                    "message": "The provided access token is invalid or has expired"
                },
                headers={"WWW-Authenticate": "Bearer"}
            )
        
        # Add authentication data to request state
        request.state.auth = auth_data
        request.state.developer = auth_data["developer"]
        request.state.developer_id = auth_data["developer_id"]
        
        logger.debug(f"Authenticated request from developer: {auth_data['email']}")
        
        try:
            # Continue to the next middleware or endpoint
            response = await call_next(request)
            return response
        except Exception as e:
            logger.error(f"Error processing authenticated request: {str(e)}")
            return JSONResponse(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                content={
                    "detail": "Internal server error",
                    "error_code": "PROCESSING_ERROR"
                }
            )


class APIKeyAuthMiddleware(BaseHTTPMiddleware):
    """
    API Key Authentication Middleware.
    
    Alternative authentication method for API endpoints using API keys.
    """
    
    def __init__(self, app, api_key_paths: Optional[list[str]] = None):
        """
        Initialize API key authentication middleware.
        
        Args:
            app: FastAPI application instance
            api_key_paths: List of path prefixes that support API key auth
        """
        super().__init__(app)
        
        # Paths that support API key authentication
        self.api_key_paths = api_key_paths or [
            "/api/v1/",
        ]
    
    def _supports_api_key_auth(self, path: str) -> bool:
        """
        Check if a path supports API key authentication.
        
        Args:
            path: Request path
            
        Returns:
            True if path supports API key authentication
        """
        return any(path.startswith(prefix) for prefix in self.api_key_paths)
    
    def _extract_api_key_from_request(self, request: Request) -> Optional[str]:
        """
        Extract API key from request.
        
        Supports multiple API key sources:
        1. Authorization header (ApiKey scheme)
        2. X-API-Key header
        3. Query parameter (api_key)
        
        Args:
            request: FastAPI request object
            
        Returns:
            API key or None if not found
        """
        # 1. Check Authorization header with ApiKey scheme
        authorization = request.headers.get("Authorization")
        if authorization and authorization.startswith("ApiKey "):
            return authorization.split(" ", 1)[1]
        
        # 2. Check X-API-Key header
        api_key = request.headers.get("X-API-Key")
        if api_key:
            return api_key
        
        # 3. Check query parameter
        api_key = request.query_params.get("api_key")
        if api_key:
            return api_key
        
        return None
    
    async def dispatch(self, request: Request, call_next):
        """
        Process the request and handle API key authentication.
        
        This middleware runs after JWT middleware and provides alternative auth.
        """
        path = request.url.path
        
        # Skip if not an API key supported path
        if not self._supports_api_key_auth(path):
            return await call_next(request)
        
        # Skip if already authenticated via JWT
        if hasattr(request.state, "auth") and request.state.auth:
            return await call_next(request)
        
        # Extract API key
        api_key = self._extract_api_key_from_request(request)
        
        if api_key:
            from app.dependencies.auth import verify_api_key
            
            # Validate API key
            developer = await verify_api_key(api_key)
            
            if developer:
                # Add authentication data to request state
                request.state.auth = {
                    "developer_id": developer.id,
                    "email": developer.email,
                    "name": developer.name,
                    "developer": developer,
                    "auth_method": "api_key"
                }
                request.state.developer = developer
                request.state.developer_id = developer.id
                
                logger.debug(f"API key authenticated: {developer.email}")
        
        return await call_next(request)