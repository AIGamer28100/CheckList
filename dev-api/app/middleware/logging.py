"""Middleware for automatic API usage logging."""

import time
from datetime import datetime, timezone
from typing import Callable

from fastapi import Request, Response
from starlette.middleware.base import BaseHTTPMiddleware

from app.models.developer import APIUsageLog
from app.services.firestore_service import firestore_service
import structlog

logger = structlog.get_logger(__name__)


class APILoggingMiddleware(BaseHTTPMiddleware):
    """Middleware to automatically log all API requests."""
    
    def __init__(self, app, log_health_checks: bool = False):
        """
        Initialize the logging middleware.
        
        Args:
            app: FastAPI application
            log_health_checks: Whether to log health check requests
        """
        super().__init__(app)
        self.log_health_checks = log_health_checks
    
    async def dispatch(self, request: Request, call_next: Callable) -> Response:
        """
        Process request and log usage data.
        
        Args:
            request: HTTP request
            call_next: Next middleware/endpoint
            
        Returns:
            HTTP response
        """
        # Skip logging for certain endpoints if configured
        if not self.log_health_checks and request.url.path in ["/health", "/docs", "/openapi.json", "/favicon.ico"]:
            return await call_next(request)
        
        # Record start time
        start_time = time.time()
        request_timestamp = datetime.now(timezone.utc)
        
        # Get request information
        method = request.method
        endpoint = request.url.path
        ip_address = self._get_client_ip(request)
        user_agent = request.headers.get("user-agent")
        
        # Get request size (approximate)
        request_size = 0
        if hasattr(request, "_body"):
            request_size = len(request._body)
        elif "content-length" in request.headers:
            try:
                request_size = int(request.headers["content-length"])
            except (ValueError, TypeError):
                request_size = 0
        
        # Extract API key and developer info
        api_key_id = None
        developer_id = None
        
        # Try to extract API key from Authorization header
        auth_header = request.headers.get("authorization")
        if auth_header and auth_header.startswith("Bearer "):
            # This would typically involve validating the token and extracting developer info
            # For now, we'll leave it as None since we'd need to implement token validation
            pass
        
        # Process the request
        error_message = None
        try:
            response = await call_next(request)
        except Exception as e:
            error_message = str(e)
            logger.error("Request processing failed", error=str(e))
            # Return a 500 error response
            from fastapi.responses import JSONResponse
            response = JSONResponse(
                status_code=500,
                content={"error": "Internal server error"}
            )
        
        # Calculate response time
        end_time = time.time()
        response_time_ms = (end_time - start_time) * 1000
        
        # Get response information
        status_code = response.status_code
        response_size = 0
        
        if hasattr(response, "headers"):
            content_length = response.headers.get("content-length")
            if content_length:
                try:
                    response_size = int(content_length)
                except (ValueError, TypeError):
                    response_size = 0
        
        # Only log API requests (skip static files, docs, etc.)
        if self._should_log_request(endpoint, method):
            # Create usage log
            usage_log = APIUsageLog(
                api_key_id=api_key_id or "anonymous",
                developer_id=developer_id or "anonymous",
                endpoint=endpoint,
                method=method,
                status_code=status_code,
                response_time_ms=round(response_time_ms, 2),
                ip_address=ip_address,
                user_agent=user_agent,
                request_size=request_size,
                response_size=response_size,
                error_message=error_message,
                metadata={
                    "query_params": str(dict(request.query_params)),
                    "path_params": str(request.path_params) if hasattr(request, "path_params") else "{}"
                },
                timestamp=request_timestamp
            )
            
            # Log usage asynchronously (don't block the response)
            try:
                await firestore_service.log_api_usage(usage_log)
            except Exception as log_error:
                logger.error("Failed to log API usage", error=str(log_error))
        
        # Log request info for monitoring
        logger.info(
            "API Request",
            method=method,
            endpoint=endpoint,
            status_code=status_code,
            response_time_ms=round(response_time_ms, 2),
            ip_address=ip_address,
            api_key_id=api_key_id,
            developer_id=developer_id
        )
        
        return response
    
    def _get_client_ip(self, request: Request) -> str:
        """
        Get the client IP address from the request.
        
        Args:
            request: HTTP request
            
        Returns:
            Client IP address
        """
        # Check for forwarded headers (common in production with load balancers)
        forwarded_for = request.headers.get("x-forwarded-for")
        if forwarded_for:
            # Take the first IP if there are multiple
            return forwarded_for.split(",")[0].strip()
        
        # Check for real IP header
        real_ip = request.headers.get("x-real-ip")
        if real_ip:
            return real_ip
        
        # Fall back to client host
        if request.client:
            return request.client.host
        
        return "unknown"
    
    def _should_log_request(self, endpoint: str, method: str) -> bool:
        """
        Determine if a request should be logged.
        
        Args:
            endpoint: Request endpoint
            method: HTTP method
            
        Returns:
            True if request should be logged
        """
        # Skip static files and documentation
        skip_patterns = [
            "/static/",
            "/favicon.ico",
            "/robots.txt",
            "/.well-known/"
        ]
        
        # Skip health checks if configured
        if not self.log_health_checks:
            skip_patterns.extend(["/health", "/docs", "/openapi.json", "/redoc"])
        
        for pattern in skip_patterns:
            if pattern in endpoint:
                return False
        
        return True


# Enhanced logging middleware with API key extraction
class EnhancedAPILoggingMiddleware(APILoggingMiddleware):
    """Enhanced middleware with API key extraction and developer identification."""
    
    async def dispatch(self, request: Request, call_next: Callable) -> Response:
        """
        Enhanced dispatch with API key extraction.
        
        Args:
            request: HTTP request
            call_next: Next middleware/endpoint
            
        Returns:
            HTTP response
        """
        # Extract API key and developer info before processing
        await self._extract_authentication_info(request)
        
        return await super().dispatch(request, call_next)
    
    async def _extract_authentication_info(self, request: Request):
        """
        Extract API key and developer information from request.
        
        Args:
            request: HTTP request
        """
        # This is where you would implement API key validation
        # and developer identification logic
        
        # Check for API key in header
        api_key = request.headers.get("x-api-key")
        if api_key:
            # Validate API key and get developer info
            # This would involve checking against your API key storage
            # For now, we'll store it in request state for later use
            request.state.api_key = api_key
        
        # Check for Bearer token
        auth_header = request.headers.get("authorization")
        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header[7:]  # Remove "Bearer " prefix
            # Validate JWT token and extract developer info
            # For now, we'll store it in request state
            request.state.bearer_token = token