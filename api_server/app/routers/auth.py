"""Authentication router."""

from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def auth_root():
    """Auth router root endpoint."""
    return {"message": "Authentication endpoints - Coming soon!"}