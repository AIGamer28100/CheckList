"""Tasks router."""

from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def tasks_root():
    """Tasks router root endpoint."""
    return {"message": "Task management endpoints - Coming soon!"}