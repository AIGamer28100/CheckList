"""Logging configuration for the CheckList API."""

import logging
import sys
from typing import Any, Dict, Optional

import structlog
from rich.console import Console
from rich.logging import RichHandler


def setup_logging(log_level: str = "INFO", log_format: str = "json") -> None:
    """Configure structured logging for the application."""
    
    # Configure standard library logging
    logging.basicConfig(
        format="%(message)s",
        level=getattr(logging, log_level.upper()),
        handlers=[
            RichHandler(
                console=Console(stderr=True),
                show_time=True,
                show_level=True,
                show_path=True,
                markup=True,
                rich_tracebacks=True,
            )
        ]
    )
    
    # Configure structlog
    processors = [
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
    ]
    
    if log_format == "json":
        processors.extend([
            structlog.processors.dict_tracebacks,
            structlog.processors.JSONRenderer()
        ])
    else:
        processors.extend([
            structlog.processors.format_exc_info,
            structlog.dev.ConsoleRenderer(colors=True)
        ])
    
    structlog.configure(
        processors=processors,
        wrapper_class=structlog.make_filtering_bound_logger(
            getattr(logging, log_level.upper())
        ),
        logger_factory=structlog.WriteLoggerFactory(),
        context_class=dict,
        cache_logger_on_first_use=True,
    )


def get_logger(name: Optional[str] = None) -> structlog.BoundLogger:
    """Get a configured logger instance."""
    return structlog.get_logger(name)


def log_request_response(
    method: str,
    url: str,
    status_code: int,
    duration_ms: float,
    request_id: Optional[str] = None,
    user_id: Optional[str] = None,
    extra_data: Optional[Dict[str, Any]] = None
) -> None:
    """Log HTTP request/response information."""
    logger = get_logger("http")
    
    log_data = {
        "method": method,
        "url": url,
        "status_code": status_code,
        "duration_ms": round(duration_ms, 2),
    }
    
    if request_id:
        log_data["request_id"] = request_id
    
    if user_id:
        log_data["user_id"] = user_id
    
    if extra_data:
        log_data.update(extra_data)
    
    # Determine log level based on status code
    if status_code < 400:
        logger.info("HTTP request processed", **log_data)
    elif status_code < 500:
        logger.warning("HTTP client error", **log_data)
    else:
        logger.error("HTTP server error", **log_data)