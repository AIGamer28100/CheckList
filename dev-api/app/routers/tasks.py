"""
Comprehensive Tasks Router with Hierarchical Functionality
Provides complete CRUD operations for hierarchical task management
"""

from typing import List, Optional, Any, Dict
from fastapi import APIRouter, Depends, HTTPException, Query, Request, status as http_status
from pydantic import ValidationError

from app.models.task import (
    TaskCreate, TaskUpdate, TaskResponse, TaskListResponse, TaskHierarchyResponse,
    SubtaskCreate, TaskMoveRequest, TaskBulkOperation, TaskStatus, TaskPriority
)
from app.services.task_service import task_service
from app.dependencies.jwt_middleware import get_authenticated_developer, get_developer_id

router = APIRouter()


@router.get("/", response_model=Dict[str, Any], summary="📋 List Tasks")
async def list_tasks(
    parent_id: Optional[str] = Query(None, description="Filter by parent task ID (null for root tasks)"),
    status: Optional[TaskStatus] = Query(None, description="Filter by task status"),
    priority: Optional[TaskPriority] = Query(None, description="Filter by task priority"),
    include_subtasks: bool = Query(False, description="Include complete subtask hierarchies"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(20, ge=1, le=100, description="Items per page"),
    developer_id: str = Depends(get_developer_id)
):
    """
    ## List Tasks with Hierarchical Support
    
    Retrieve tasks with powerful filtering, pagination, and hierarchical options.
    
    ### Features:
    - **Hierarchical Filtering**: Get root tasks or filter by parent
    - **Status & Priority Filtering**: Filter by task status and priority
    - **Subtask Loading**: Optionally include complete subtask trees
    - **Pagination**: Efficient pagination for large task lists
    
    ### Query Parameters:
    - `parent_id`: Filter by parent task (null for root-level tasks)
    - `status`: Filter by task status (todo, in_progress, completed, cancelled)
    - `priority`: Filter by priority (low, medium, high, urgent)
    - `include_subtasks`: Load complete hierarchical trees
    - `page` & `page_size`: Pagination controls
    """
    try:
        result = await task_service.list_tasks(
            developer_id=developer_id,
            parent_id=parent_id,
            status=status,
            priority=priority,
            include_subtasks=include_subtasks,
            page=page,
            page_size=page_size
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=http_status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to list tasks: {str(e)}"
        )


@router.post("/", response_model=TaskResponse, summary="➕ Create Task")
async def create_task(
    task_data: TaskCreate,
    developer_id: str = Depends(get_developer_id)
):
    """
    ## Create New Task
    
    Create a new task with optional parent-child relationships.
    
    ### Features:
    - **Hierarchical Support**: Specify parent_task_id for subtasks
    - **Rich Metadata**: Support for priorities, due dates, tags, etc.
    - **Integration Ready**: GitHub, Calendar, and location support
    - **Validation**: Comprehensive input validation
    
    ### Request Body:
    Complete task data including title, description, priority, due dates, etc.
    """
    try:
        return await task_service.create_task(task_data, developer_id)
    except ValueError as e:
        raise HTTPException(
            status_code=http_status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=http_status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create task: {str(e)}"
        )


@router.get("/{task_id}", response_model=TaskResponse, summary="🔍 Get Task")
async def get_task(
    task_id: str,
    include_subtasks: bool = Query(False, description="Include subtask hierarchy"),
    developer_id: str = Depends(get_developer_id)
):
    """
    ## Get Task by ID
    
    Retrieve a specific task with optional subtask hierarchy.
    
    ### Features:
    - **Single Task**: Get specific task details
    - **Hierarchical Loading**: Optionally load complete subtask tree
    - **Computed Fields**: Includes completion percentages, overdue status
    - **Security**: Only returns tasks owned by authenticated developer
    """
    task = await task_service.get_task(task_id, developer_id)
    
    if not task:
        raise HTTPException(
            status_code=http_status.HTTP_404_NOT_FOUND,
            detail="Task not found"
        )
    
    if include_subtasks:
        task = await task_service._load_task_hierarchy(task, developer_id)
    
    return task


@router.get("/{task_id}/hierarchy", response_model=TaskHierarchyResponse, summary="🌳 Get Task Hierarchy")
async def get_task_hierarchy(
    task_id: str,
    developer_id: str = Depends(get_developer_id)
):
    """
    ## Get Complete Task Hierarchy
    
    Retrieve a complete task hierarchy with statistics and analytics.
    
    ### Features:
    - **Complete Tree**: Full task hierarchy from root
    - **Statistics**: Total subtasks, max depth, completion rates
    - **Analytics**: Breakdown by status, priority, and completion
    - **Computed Data**: Overall completion percentages and summaries
    """
    hierarchy = await task_service.get_task_hierarchy(task_id, developer_id)
    
    if not hierarchy:
        raise HTTPException(
            status_code=http_status.HTTP_404_NOT_FOUND,
            detail="Task not found"
        )
    
    return hierarchy


@router.put("/{task_id}", response_model=TaskResponse, summary="✏️ Update Task")
async def update_task(
    task_id: str,
    task_data: TaskUpdate,
    developer_id: str = Depends(get_developer_id)
):
    """
    ## Update Task
    
    Update any task fields with automatic timestamp management.
    
    ### Features:
    - **Partial Updates**: Update only specified fields
    - **Status Management**: Automatic completion timestamp handling
    - **Validation**: Input validation and business rule enforcement
    - **Hierarchy Aware**: Maintains hierarchical relationships
    """
    try:
        updated_task = await task_service.update_task(task_id, task_data, developer_id)
        
        if not updated_task:
            raise HTTPException(
                status_code=http_status.HTTP_404_NOT_FOUND,
                detail="Task not found"
            )
        
        return updated_task
    except ValueError as e:
        raise HTTPException(
            status_code=http_status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=http_status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to update task: {str(e)}"
        )


@router.delete("/{task_id}", summary="🗑️ Delete Task")
async def delete_task(
    task_id: str,
    cascade: bool = Query(False, description="Delete subtasks as well"),
    developer_id: str = Depends(get_developer_id)
):
    """
    ## Delete Task
    
    Delete a task with optional cascade deletion of subtasks.
    
    ### Features:
    - **Safe Deletion**: Prevents deletion of tasks with subtasks by default
    - **Cascade Option**: Optionally delete entire task hierarchy
    - **Validation**: Ensures no orphaned subtasks remain
    - **Security**: Only allows deletion of owned tasks
    
    ### Query Parameters:
    - `cascade`: Set to true to delete all subtasks recursively
    """
    try:
        deleted = await task_service.delete_task(task_id, developer_id, cascade)
        
        if not deleted:
            raise HTTPException(
                status_code=http_status.HTTP_404_NOT_FOUND,
                detail="Task not found"
            )
        
        return {"message": "Task deleted successfully", "cascade": cascade}
    except ValueError as e:
        raise HTTPException(
            status_code=http_status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=http_status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to delete task: {str(e)}"
        )


@router.post("/{task_id}/subtasks", response_model=TaskResponse, summary="➕ Create Subtask")
async def create_subtask(
    task_id: str,
    subtask_data: SubtaskCreate,
    developer_id: str = Depends(get_developer_id)
):
    """
    ## Create Subtask
    
    Create a new subtask under an existing parent task.
    
    ### Features:
    - **Hierarchical Creation**: Automatically sets parent relationship
    - **Inheritance**: Can inherit properties from parent task
    - **Validation**: Ensures parent task exists and is accessible
    - **Simplified Input**: Streamlined subtask creation interface
    """
    try:
        return await task_service.create_subtask(task_id, subtask_data, developer_id)
    except ValueError as e:
        raise HTTPException(
            status_code=http_status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=http_status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create subtask: {str(e)}"
        )


@router.put("/{task_id}/move", response_model=TaskResponse, summary="🔄 Move Task")
async def move_task(
    task_id: str,
    move_data: TaskMoveRequest,
    developer_id: str = Depends(get_developer_id)
):
    """
    ## Move Task in Hierarchy
    
    Move a task to a different parent or change its position.
    
    ### Features:
    - **Reparenting**: Move task to different parent or root level
    - **Cycle Prevention**: Prevents circular dependencies
    - **Position Control**: Specify position within new parent's children
    - **Validation**: Ensures all referenced tasks exist and are accessible
    
    ### Request Body:
    - `new_parent_id`: New parent task ID (null for root level)
    - `position`: Position in new parent's children list (optional)
    """
    try:
        moved_task = await task_service.move_task(task_id, move_data, developer_id)
        
        if not moved_task:
            raise HTTPException(
                status_code=http_status.HTTP_404_NOT_FOUND,
                detail="Task not found"
            )
        
        return moved_task
    except ValueError as e:
        raise HTTPException(
            status_code=http_status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=http_status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to move task: {str(e)}"
        )


@router.put("/bulk-update", response_model=List[TaskResponse], summary="🔄 Bulk Update Tasks")
async def bulk_update_tasks(
    task_ids: List[str],
    update_data: TaskUpdate,
    developer_id: str = Depends(get_developer_id)
):
    """
    ## Bulk Update Tasks
    
    Update multiple tasks with the same data in a single operation.
    
    ### Features:
    - **Batch Processing**: Update multiple tasks efficiently
    - **Partial Updates**: Apply same update to all selected tasks
    - **Error Handling**: Continues processing even if some tasks fail
    - **Security**: Only updates tasks owned by authenticated developer
    
    ### Request Body:
    - Array of task IDs to update
    - Update data to apply to all tasks
    """
    try:
        updated_tasks = await task_service.bulk_update_tasks(task_ids, update_data, developer_id)
        return updated_tasks
    except Exception as e:
        raise HTTPException(
            status_code=http_status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to bulk update tasks: {str(e)}"
        )


@router.get("/stats/summary", summary="📊 Task Statistics")
async def get_task_statistics(
    developer_id: str = Depends(get_developer_id)
):
    """
    ## Task Statistics Summary
    
    Get comprehensive statistics about your tasks and hierarchies.
    
    ### Features:
    - **Overall Stats**: Total tasks, completion rates, etc.
    - **Status Breakdown**: Tasks by status (todo, in progress, completed)
    - **Priority Analysis**: Distribution by priority levels
    - **Hierarchy Metrics**: Depth analysis, subtask statistics
    """
    try:
        # Get all root tasks with hierarchies
        result = await task_service.list_tasks(
            developer_id=developer_id,
            parent_id=None,
            include_subtasks=True,
            page_size=1000  # Large limit for stats
        )
        
        tasks = result["tasks"]
        
        # Calculate comprehensive statistics
        total_tasks = 0
        completed_tasks = 0
        in_progress_tasks = 0
        todo_tasks = 0
        overdue_tasks = 0
        
        by_priority = {"low": 0, "medium": 0, "high": 0, "urgent": 0}
        by_status = {"todo": 0, "in_progress": 0, "completed": 0, "cancelled": 0}
        
        def count_task_stats(task: TaskResponse):
            nonlocal total_tasks, completed_tasks, in_progress_tasks, todo_tasks, overdue_tasks
            
            total_tasks += 1
            by_priority[task.priority.value] += 1
            by_status[task.status.value] += 1
            
            if task.status == TaskStatus.COMPLETED:
                completed_tasks += 1
            elif task.status == TaskStatus.IN_PROGRESS:
                in_progress_tasks += 1
            else:
                todo_tasks += 1
            
            if task.is_overdue:
                overdue_tasks += 1
            
            # Recursively count subtasks
            for subtask in task.subtasks:
                count_task_stats(subtask)
        
        # Count all tasks including subtasks
        for task in tasks:
            count_task_stats(task)
        
        completion_rate = (completed_tasks / total_tasks * 100) if total_tasks > 0 else 0
        
        return {
            "total_tasks": total_tasks,
            "root_tasks": len(tasks),
            "completed_tasks": completed_tasks,
            "in_progress_tasks": in_progress_tasks,
            "todo_tasks": todo_tasks,
            "overdue_tasks": overdue_tasks,
            "completion_rate": round(completion_rate, 2),
            "by_priority": by_priority,
            "by_status": by_status,
            "hierarchy_stats": {
                "total_hierarchies": len(tasks),
                "average_depth": sum(task_service._calculate_max_depth(task) for task in tasks) / len(tasks) if tasks else 0
            }
        }
    except Exception as e:
        raise HTTPException(
            status_code=http_status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get task statistics: {str(e)}"
        )