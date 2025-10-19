"""
Rate limiting middleware for FastAPI
"""
import time
from typing import Callable, Optional
from fastapi import Request, Response, HTTPException, status
from starlette.middleware.base import BaseHTTPMiddleware
import structlog

from app.services.rate_limiter import check_rate_limit, get_rate_limit_info
from app.dependencies.auth import verify_api_key

logger = structlog.get_logger(__name__)


class RateLimitMiddleware(BaseHTTPMiddleware):
    """
    Middleware to enforce rate limiting on API requests.
    """
    
    def __init__(
        self,
        app,
        default_rate_limit: int = 1000,
        default_window_seconds: int = 3600,
        exclude_paths: Optional[list] = None
    ):
        """
        Initialize rate limit middleware.
        
        Args:
            app: FastAPI application
            default_rate_limit: Default requests per window
            default_window_seconds: Default time window (1 hour)
            exclude_paths: Paths to exclude from rate limiting
        """
        super().__init__(app)
        self.default_rate_limit = default_rate_limit
        self.default_window_seconds = default_window_seconds
        self.exclude_paths = exclude_paths or [
            "/health",
            "/",
            "/docs",
            "/redoc",
            "/openapi.json",
            "/portal",  # Developer portal pages
            "/static"   # Static files
        ]
    
    async def dispatch(self, request: Request, call_next: Callable) -> Response:
        """Process request with rate limiting."""
        
        # Skip rate limiting for excluded paths
        if any(request.url.path.startswith(path) for path in self.exclude_paths):
            return await call_next(request)
        
        # Skip rate limiting for OPTIONS requests (CORS preflight)
        if request.method == "OPTIONS":
            return await call_next(request)
        
        # Extract API key from request
        api_key = await self._extract_api_key(request)
        
        if not api_key:
            # No API key provided - use IP-based rate limiting for anonymous requests
            api_key_id = f"anonymous:{self._get_client_ip(request)}"
            rate_limit = self.default_rate_limit // 10  # Stricter limit for anonymous
            window_seconds = self.default_window_seconds
        else:
            # Verify API key and get rate limits
            try:
                developer = await verify_api_key(api_key)
                if not developer:
                    raise HTTPException(
                        status_code=status.HTTP_401_UNAUTHORIZED,
                        detail="Invalid API key"
                    )
                
                # Get API key info from database to determine rate limits
                api_key_info = await self._get_api_key_info(api_key)
                api_key_id = api_key_info.get("id", api_key[:16])  # Use key prefix as ID
                rate_limit = api_key_info.get("rate_limit", self.default_rate_limit)
                window_seconds = api_key_info.get("window_seconds", self.default_window_seconds)
                
            except Exception as e:
                logger.warning(f"Error verifying API key: {e}")
                # Fall back to anonymous rate limiting
                api_key_id = f"anonymous:{self._get_client_ip(request)}"
                rate_limit = self.default_rate_limit // 10
                window_seconds = self.default_window_seconds
        
        # Check rate limit
        try:
            is_allowed, rate_info = await check_rate_limit(
                api_key_id, rate_limit, window_seconds
            )
            
            if not is_allowed:
                # Rate limit exceeded
                logger.warning(
                    "Rate limit exceeded",
                    api_key_id=api_key_id,
                    rate_limit=rate_limit,
                    remaining=rate_info['remaining']
                )
                
                response = Response(
                    content='{"detail":"Rate limit exceeded"}',
                    status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                    media_type="application/json"
                )
                
                # Add rate limit headers
                self._add_rate_limit_headers(response, rate_info)
                return response
            
            # Process the request
            response = await call_next(request)
            
            # Add rate limit headers to successful responses
            self._add_rate_limit_headers(response, rate_info)
            
            return response
            
        except Exception as e:
            logger.error(f"Error in rate limiting: {e}")
            # Continue without rate limiting on error
            return await call_next(request)
    
    async def _extract_api_key(self, request: Request) -> Optional[str]:
        """Extract API key from request headers or query parameters."""
        # Check Authorization header
        auth_header = request.headers.get("Authorization")
        if auth_header and auth_header.startswith("Bearer "):
            return auth_header[7:]  # Remove "Bearer " prefix
        
        # Check X-API-Key header
        api_key_header = request.headers.get("X-API-Key")
        if api_key_header:
            return api_key_header
        
        # Check query parameter
        return request.query_params.get("api_key")
    
    def _get_client_ip(self, request: Request) -> str:
        """Get client IP address from request."""
        # Check for forwarded headers (for reverse proxies)
        forwarded_for = request.headers.get("X-Forwarded-For")
        if forwarded_for:
            return forwarded_for.split(",")[0].strip()
        
        # Check for real IP header
        real_ip = request.headers.get("X-Real-IP")
        if real_ip:
            return real_ip
        
        # Fall back to direct client IP
        if hasattr(request.client, "host"):
            return request.client.host
        
        return "unknown"
    
    async def _get_api_key_info(self, api_key: str) -> dict:
        """Get API key information from database."""
        # This is a simplified version - in production, this would query the database
        # For now, return default values with some demo data
        if api_key.startswith("demo"):
            return {
                "id": api_key[:16],
                "rate_limit": 10000,  # High limit for demo key
                "window_seconds": 3600
            }
        
        return {
            "id": api_key[:16],
            "rate_limit": self.default_rate_limit,
            "window_seconds": self.default_window_seconds
        }
    
    def _add_rate_limit_headers(self, response: Response, rate_info: dict):
        """Add rate limiting headers to response."""
        response.headers["X-RateLimit-Limit"] = str(rate_info['limit'])
        response.headers["X-RateLimit-Remaining"] = str(rate_info['remaining'])
        response.headers["X-RateLimit-Reset"] = str(rate_info['reset_time'])
        
        if rate_info.get('retry_after'):
            response.headers["Retry-After"] = str(rate_info['retry_after'])


async def get_rate_limit_status(api_key: str) -> dict:
    """
    Get current rate limit status for an API key.
    This can be used in endpoints to show developers their current usage.
    """
    try:
        # Extract API key ID (in production, this would query the database)
        api_key_id = api_key[:16] if api_key else f"anonymous:{int(time.time())}"
        
        rate_info = await get_rate_limit_info(api_key_id)
        
        if not rate_info:
            return {
                "limit": 1000,
                "remaining": 1000,
                "used": 0,
                "reset_time": int(time.time() + 3600),
                "status": "active"
            }
        
        return {
            **rate_info,
            "status": "active" if rate_info['remaining'] > 0 else "exceeded"
        }
        
    except Exception as e:
        logger.error(f"Error getting rate limit status: {e}")
        return {
            "limit": 0,
            "remaining": 0,
            "used": 0,
            "reset_time": int(time.time() + 3600),
            "status": "error"
        }