"""Main FastAPI application for CheckList API."""

import os
import sys
from contextlib import asynccontextmanager
from typing import Any, Dict

import structlog
import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.config import settings
from app.database.firestore import FirestoreClient
from app.routers import auth, tasks, users, api_keys, consent, analytics, test, documentation, attachments
from app.middleware.logging import APILoggingMiddleware
from app.utils.logging import setup_logging


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager."""
    # Startup
    logger = structlog.get_logger()
    logger.info("🚀 Starting CheckList API server", version="1.0.0")
    
    # Initialize Firestore client
    try:
        firestore_client = FirestoreClient()
        await firestore_client.initialize()
        app.state.firestore = firestore_client
        logger.info("✅ Firestore client initialized successfully")
    except Exception as e:
        logger.error("❌ Failed to initialize Firestore client", error=str(e))
        sys.exit(1)
    
    yield
    
    # Shutdown
    logger.info("🛑 Shutting down CheckList API server")
    if hasattr(app.state, 'firestore'):
        await app.state.firestore.close()
        logger.info("✅ Firestore client closed")


# Create FastAPI application
description = """
## CheckList API - Advanced Task Management Platform 📋

A powerful, high-performance RESTful API designed for modern task management applications
with seamless integrations, developer-friendly features, and enterprise-grade security.

### 🚀 Key Features

* **OAuth Authentication**: Secure Google OAuth integration for user authentication
* **API Key Management**: Complete CRUD operations for developer API keys
* **Rate Limiting**: Advanced token-bucket rate limiting per API key
* **Analytics & Monitoring**: Comprehensive API usage analytics and real-time monitoring  
* **Consent System**: OAuth-like consent flow for third-party integrations
* **Developer Portal**: Full-featured developer dashboard and documentation

### 🛡️ Security

* **JWT Authentication**: Secure token-based authentication
* **API Key Security**: Hashed storage and validation of API keys
* **Rate Limiting**: Per-key rate limiting with configurable quotas
* **CORS Protection**: Properly configured cross-origin resource sharing
* **Input Validation**: Comprehensive request/response validation

### 📊 Analytics & Monitoring

* **Usage Analytics**: Detailed API usage statistics and trends
* **Real-time Metrics**: Live monitoring of API performance and health
* **Error Tracking**: Comprehensive error logging and analysis
* **Geographic Analytics**: IP-based usage distribution tracking

### 🔗 Integration Ready

* **RESTful Design**: Clean, predictable API endpoints following REST principles
* **OpenAPI Spec**: Complete OpenAPI 3.0 specification with interactive documentation
* **Multi-format Support**: JSON responses with proper content negotiation
* **Webhook Support**: Real-time notifications for API events

### 📖 Getting Started

1. **Authentication**: Get started with Google OAuth or API keys
2. **API Keys**: Generate your API key at `/api/v1/api-keys/`  
3. **Documentation**: Explore endpoints in the interactive docs below
4. **Support**: Visit our developer portal for guides and examples

### 🏗️ API Architecture

Built with **FastAPI** for maximum performance and **Firestore** for reliable cloud storage.
Designed for scalability with async/await patterns and efficient database operations.
"""

tags_metadata = [
    {
        "name": "Authentication",
        "description": "🔐 **User authentication and authorization**. OAuth flows, login/logout, and session management.",
        "externalDocs": {
            "description": "Authentication Guide",
            "url": "https://docs.checklist.aigamer.dev/auth",
        },
    },
    {
        "name": "API Keys",
        "description": "🔑 **API key management for developers**. Create, manage, and monitor API keys with rate limiting and analytics.",
        "externalDocs": {
            "description": "API Keys Documentation",
            "url": "https://docs.checklist.aigamer.dev/api-keys",
        },
    },
    {
        "name": "OAuth Consent",
        "description": "✅ **OAuth-like consent system**. Manage user consent for third-party integrations with scoped permissions.",
        "externalDocs": {
            "description": "Consent Flow Guide",
            "url": "https://docs.checklist.aigamer.dev/consent",
        },
    },
    {
        "name": "Analytics",
        "description": "📊 **API usage analytics and monitoring**. Real-time metrics, usage statistics, and performance insights.",
        "externalDocs": {
            "description": "Analytics Documentation",
            "url": "https://docs.checklist.aigamer.dev/analytics",
        },
    },
    {
        "name": "Tasks",
        "description": "📋 **Core task management**. CRUD operations for tasks with filtering, search, and batch operations.",
        "externalDocs": {
            "description": "Tasks API Guide",
            "url": "https://docs.checklist.aigamer.dev/tasks",
        },
    },
    {
        "name": "Attachments",
        "description": "📎 **Rich task content and file attachments**. Upload files, images, voice memos, and link attachments to tasks.",
        "externalDocs": {
            "description": "Attachments API Guide",
            "url": "https://docs.checklist.aigamer.dev/attachments",
        },
    },
    {
        "name": "Users",
        "description": "👥 **User profile and account management**. User data, preferences, and account operations.",
        "externalDocs": {
            "description": "Users API Documentation",
            "url": "https://docs.checklist.aigamer.dev/users",
        },
    },
    {
        "name": "Testing", 
        "description": "🧪 **Development and testing utilities**. Debug endpoints, rate limiting demos, and development tools.",
    },
    {
        "name": "Developer Portal",
        "description": "🏗️ **Web-based developer dashboard**. Interactive portal for managing API keys, viewing analytics, and accessing documentation.",
    },
    {
        "name": "API Documentation",
        "description": "📚 **API documentation and examples**. Comprehensive guides, code samples, and best practices for API integration.",
        "externalDocs": {
            "description": "Complete API Documentation",
            "url": "https://docs.checklist.aigamer.dev",
        },
    },
]

app = FastAPI(
    title="CheckList API",
    description=description,
    version="1.0.0",
    openapi_tags=tags_metadata,
    docs_url="/docs" if settings.debug else None,
    redoc_url="/redoc" if settings.debug else None,
    openapi_url="/openapi.json" if settings.debug else None,
    lifespan=lifespan,
    contact={
        "name": "CheckList API Support",
        "email": "support@checklist.aigamer.dev",
    },
    license_info={
        "name": "MIT License",
        "url": "https://opensource.org/licenses/MIT",
    },
    servers=[
        {
            "url": "http://localhost:8000",
            "description": "Development server"
        },
        {
            "url": "https://api.checklist.aigamer.dev",
            "description": "Production server"
        }
    ]
)

# Setup logging
setup_logging(settings.log_level, settings.log_format)
logger = structlog.get_logger()

# Setup enhanced API documentation
from app.utils.documentation import setup_api_documentation
setup_api_documentation(app)

# Add security middleware
if not settings.debug:
    app.add_middleware(
        TrustedHostMiddleware,
        allowed_hosts=["*"],  # Configure based on your deployment
    )

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,
    allow_credentials=True,
    allow_methods=settings.allowed_methods,
    allow_headers=settings.allowed_headers,
)

# Add rate limiting middleware
from app.middleware.rate_limiting import RateLimitMiddleware
app.add_middleware(
    RateLimitMiddleware,
    default_rate_limit=settings.default_rate_limit,
    default_window_seconds=3600,  # 1 hour
    exclude_paths=["/health", "/", "/docs", "/redoc", "/openapi.json", "/portal", "/static"]
)

# Add JWT authentication middleware
from app.middleware.jwt_auth import JWTAuthMiddleware, APIKeyAuthMiddleware
app.add_middleware(
    JWTAuthMiddleware,
    protected_paths=[
        "/api/v1/tasks",
        "/api/v1/users", 
        "/api/v1/analytics",
        "/portal/api",
    ]
)

# Add API key authentication middleware (alternative auth method)
app.add_middleware(
    APIKeyAuthMiddleware,
    api_key_paths=["/api/v1/"]
)

# Add API logging middleware
app.add_middleware(
    APILoggingMiddleware,
    log_health_checks=False  # Don't log health check requests
)

# Include routers
from app.routers import status
app.include_router(status.router, tags=["API Status"])
app.include_router(auth.router, prefix="/api/v1", tags=["Authentication"])
app.include_router(api_keys.router, prefix="/api/v1", tags=["API Keys"])
app.include_router(consent.router, prefix="/api/v1", tags=["OAuth Consent"])
app.include_router(analytics.router, prefix="/api/v1", tags=["Analytics"])
app.include_router(tasks.router, prefix="/api/v1", tags=["Tasks"])
app.include_router(attachments.router, prefix="/api/v1", tags=["Attachments"])
app.include_router(users.router, prefix="/api/v1/users", tags=["Users"])
app.include_router(test.router, prefix="/api/v1", tags=["Testing"])
app.include_router(documentation.router, prefix="/api/v1", tags=["API Documentation"])

# Add developer portal routes
try:
    from app.routers.developer_portal import router as developer_portal_router
    app.include_router(developer_portal_router, prefix="/portal", tags=["Developer Portal"])
    logger.info("✅ Developer portal routes loaded")
except ImportError as e:
    logger.warning("⚠️ Developer portal routes not available", error=str(e))

# Mount static files for developer portal
static_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "static")
templates_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "templates")

if os.path.exists(static_dir):
    app.mount("/static", StaticFiles(directory=static_dir), name="static")
    logger.info(f"✅ Static files mounted from {static_dir}")

if os.path.exists(templates_dir):
    logger.info(f"✅ Templates directory found at {templates_dir}")
else:
    logger.warning(f"⚠️ Templates directory not found at {templates_dir}")


@app.get("/", include_in_schema=False)
async def root() -> Dict[str, Any]:
    """Root endpoint with API information."""
    return {
        "message": "🚀 CheckList API Server",
        "version": "1.0.0",
        "status": "healthy",
        "docs": "/docs" if settings.debug else "Documentation disabled in production",
        "health": "/health",
    }


@app.get("/health", tags=["Health"])
async def health_check() -> Dict[str, Any]:
    """Health check endpoint."""
    try:
        # Check Firestore connection
        firestore_status = "healthy"
        if hasattr(app.state, 'firestore'):
            # Simple test query to check Firestore connectivity
            await app.state.firestore.test_connection()
        else:
            firestore_status = "not_initialized"
        
        from datetime import datetime, timezone
        return {
            "status": "healthy",
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "version": "1.0.0",
            "environment": settings.environment,
            "services": {
                "firestore": firestore_status,
            },
        }
    except Exception as e:
        logger.error("Health check failed", error=str(e))
        raise HTTPException(status_code=503, detail="Service unhealthy")


@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    """Global exception handler."""
    logger.error(
        "Unhandled exception",
        error=str(exc),
        path=request.url.path,
        method=request.method,
        exc_info=True,
    )
    
    if settings.debug:
        return JSONResponse(
            status_code=500,
            content={
                "detail": "Internal server error",
                "error": str(exc),
                "type": type(exc).__name__,
            },
        )
    
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"},
    )


def start_server() -> None:
    """Start the server with uvicorn."""
    uvicorn.run(
        "app.main:app",
        host=settings.api_host,
        port=settings.api_port,
        workers=settings.api_workers,
        reload=settings.debug,
        log_config=None,  # We use structlog
    )


if __name__ == "__main__":
    start_server()