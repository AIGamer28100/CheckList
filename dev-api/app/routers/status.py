"""
API Status and Health Check Router
Provides comprehensive API status, health checks, and documentation endpoints
"""

from fastapi import APIRouter, Response
from typing import Dict, Any
import time
from datetime import datetime, timezone

router = APIRouter(tags=["API Status"])


@router.get("/", summary="🏠 API Welcome")
async def api_welcome():
    """
    ## Welcome to CheckList API
    
    A comprehensive task management API with enterprise-grade features.
    """
    return {
        "message": "Welcome to CheckList API - Advanced Task Management Platform",
        "version": "1.0.0",
        "status": "operational",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "documentation": {
            "interactive_docs": "/docs",
            "redoc": "/redoc", 
            "openapi_spec": "/openapi.json",
            "examples": "/api/v1/docs-examples/",
            "api_reference": "/api/v1/docs-examples/api-reference",
            "jwt_guide": "/api/v1/docs-examples/jwt-middleware-guide"
        },
        "authentication": {
            "jwt_bearer": "Primary authentication method",
            "api_key": "Alternative authentication for programmatic access",
            "oauth": "Google OAuth integration available"
        },
        "features": [
            "JWT Authentication Middleware",
            "API Key Management",
            "Rate Limiting",
            "Real-time Analytics", 
            "Developer Portal",
            "Comprehensive Documentation"
        ],
        "getting_started": {
            "step_1": "Visit /docs for interactive API documentation",
            "step_2": "Authenticate via /api/v1/auth/google/login",
            "step_3": "Generate API keys at /api/v1/api-keys/",
            "step_4": "Start managing tasks at /api/v1/tasks/"
        }
    }


@router.get("/health", summary="🏥 Health Check")
async def health_check():
    """
    ## Health Check
    
    Simple health check endpoint for monitoring and load balancers.
    """
    return {
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "uptime": time.time(),
        "service": "CheckList API",
        "version": "1.0.0"
    }


@router.get("/status", summary="📊 API Status")
async def api_status():
    """
    ## Comprehensive API Status
    
    Detailed status information including authentication, middleware, and services.
    """
    return {
        "api": {
            "name": "CheckList API",
            "version": "1.0.0",
            "status": "operational",
            "uptime": time.time(),
            "timestamp": datetime.now(timezone.utc).isoformat()
        },
        "authentication": {
            "jwt_middleware": "active",
            "api_key_middleware": "active",
            "oauth_integration": "active",
            "protected_routes": [
                "/api/v1/tasks",
                "/api/v1/users",
                "/api/v1/analytics", 
                "/portal/api"
            ]
        },
        "middleware": {
            "cors": "active",
            "rate_limiting": "active", 
            "jwt_auth": "active",
            "api_key_auth": "active",
            "logging": "active"
        },
        "services": {
            "firestore": "connected",
            "oauth": "configured",
            "email": "configured",
            "rate_limiter": "active"
        },
        "endpoints": {
            "total": "25+",
            "public": 8,
            "protected": 17,
            "documentation": 6
        },
        "documentation": {
            "swagger_ui": "/docs",
            "redoc": "/redoc",
            "openapi_spec": "/openapi.json",
            "examples": "/api/v1/docs-examples/",
            "testing_guide": "Available in repository"
        }
    }