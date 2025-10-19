"""Users router."""

from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def users_root():
    """Users router root endpoint."""
    return {"message": "User management endpoints - Coming soon!"}