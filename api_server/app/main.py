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

from app.config import settings
from app.database.firestore import FirestoreClient
from app.routers import auth, tasks, users
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
app = FastAPI(
    title="CheckList API",
    description="A high-performance RESTful API for task management",
    version="1.0.0",
    docs_url="/docs" if settings.debug else None,
    redoc_url="/redoc" if settings.debug else None,
    openapi_url="/openapi.json" if settings.debug else None,
    lifespan=lifespan,
)

# Setup logging
setup_logging(settings.log_level, settings.log_format)
logger = structlog.get_logger()

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

# Include routers
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(tasks.router, prefix="/api/v1/tasks", tags=["Tasks"])
app.include_router(users.router, prefix="/api/v1/users", tags=["Users"])


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
        
        return {
            "status": "healthy",
            "timestamp": structlog.stdlib.get_logger().info,
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