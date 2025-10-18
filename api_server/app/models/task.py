"""Task-related Pydantic models."""

from datetime import datetime
from enum import Enum
from typing import Dict, List, Optional

from pydantic import BaseModel, Field, ConfigDict


class TaskStatus(str, Enum):
    """Task status enumeration."""
    TODO = "todo"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class TaskPriority(str, Enum):
    """Task priority enumeration."""
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    URGENT = "urgent"


class TaskBase(BaseModel):
    """Base task model with common fields."""
    model_config = ConfigDict(from_attributes=True)
    
    title: str = Field(..., min_length=1, max_length=200, description="Task title")
    description: Optional[str] = Field(None, max_length=2000, description="Task description")
    status: TaskStatus = Field(default=TaskStatus.TODO, description="Task status")
    priority: TaskPriority = Field(default=TaskPriority.MEDIUM, description="Task priority")
    due_date: Optional[datetime] = Field(None, description="Task due date")
    reminder_time: Optional[datetime] = Field(None, description="Reminder time")
    tags: List[str] = Field(default_factory=list, description="Task tags")
    location: Optional[str] = Field(None, max_length=200, description="Task location")
    github_issue_url: Optional[str] = Field(None, description="GitHub issue URL")
    github_repo_id: Optional[str] = Field(None, description="GitHub repository ID")
    calendar_event_id: Optional[str] = Field(None, description="Calendar event ID")
    attachments: List[str] = Field(default_factory=list, description="File attachments")
    parent_task_id: Optional[str] = Field(None, description="Parent task ID for subtasks")
    is_recurring: bool = Field(default=False, description="Whether task is recurring")
    recurrence_pattern: Optional[str] = Field(None, description="Recurrence pattern")
    estimated_minutes: Optional[int] = Field(None, ge=1, description="Estimated time in minutes")
    actual_minutes: Optional[int] = Field(None, ge=0, description="Actual time spent in minutes")
    completion_percentage: int = Field(default=0, ge=0, le=100, description="Completion percentage")
    metadata: Dict[str, str] = Field(default_factory=dict, description="Additional metadata")


class TaskCreate(TaskBase):
    """Model for creating a new task."""
    pass


class TaskUpdate(BaseModel):
    """Model for updating an existing task."""
    model_config = ConfigDict(from_attributes=True)
    
    title: Optional[str] = Field(None, min_length=1, max_length=200)
    description: Optional[str] = Field(None, max_length=2000)
    status: Optional[TaskStatus] = None
    priority: Optional[TaskPriority] = None
    due_date: Optional[datetime] = None
    reminder_time: Optional[datetime] = None
    tags: Optional[List[str]] = None
    location: Optional[str] = Field(None, max_length=200)
    github_issue_url: Optional[str] = None
    github_repo_id: Optional[str] = None
    calendar_event_id: Optional[str] = None
    attachments: Optional[List[str]] = None
    parent_task_id: Optional[str] = None
    is_recurring: Optional[bool] = None
    recurrence_pattern: Optional[str] = None
    estimated_minutes: Optional[int] = Field(None, ge=1)
    actual_minutes: Optional[int] = Field(None, ge=0)
    completion_percentage: Optional[int] = Field(None, ge=0, le=100)
    metadata: Optional[Dict[str, str]] = None


class TaskResponse(TaskBase):
    """Model for task responses."""
    id: str = Field(..., description="Task ID")
    created_by: str = Field(..., description="User ID who created the task")
    created_at: datetime = Field(..., description="Task creation timestamp")
    updated_at: Optional[datetime] = Field(None, description="Last update timestamp")
    completed_at: Optional[datetime] = Field(None, description="Completion timestamp")


class TaskListResponse(BaseModel):
    """Model for paginated task list responses."""
    model_config = ConfigDict(from_attributes=True)
    
    tasks: List[TaskResponse] = Field(..., description="List of tasks")
    total_count: int = Field(..., description="Total number of tasks")
    page: int = Field(..., description="Current page number")
    page_size: int = Field(..., description="Number of items per page")
    total_pages: int = Field(..., description="Total number of pages")


class TaskStatsResponse(BaseModel):
    """Model for task statistics response."""
    model_config = ConfigDict(from_attributes=True)
    
    total_tasks: int = Field(..., description="Total number of tasks")
    completed_tasks: int = Field(..., description="Number of completed tasks")
    pending_tasks: int = Field(..., description="Number of pending tasks")
    overdue_tasks: int = Field(..., description="Number of overdue tasks")
    completion_rate: float = Field(..., description="Completion rate percentage")
    by_priority: Dict[str, int] = Field(..., description="Tasks count by priority")
    by_status: Dict[str, int] = Field(..., description="Tasks count by status")