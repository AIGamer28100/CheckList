"""
Task Service for Hierarchical Task Management
Provides comprehensive task operations including hierarchical functionality
"""

from datetime import datetime, timezone
from typing import Dict, List, Optional, Any, Tuple
from uuid import uuid4

from app.models.task import (
    TaskCreate, TaskUpdate, TaskResponse, TaskHierarchyResponse,
    SubtaskCreate, TaskMoveRequest, TaskStatus, TaskPriority
)
from app.services.firestore_service import firestore_service


class TaskService:
    """Service for managing hierarchical tasks."""
    
    def __init__(self):
        self.collection_name = "tasks"
    
    async def create_task(self, task_data: TaskCreate, developer_id: str) -> TaskResponse:
        """
        Create a new task.
        
        Args:
            task_data: Task creation data
            developer_id: ID of the developer creating the task
            
        Returns:
            Created task response
        """
        task_id = str(uuid4())
        now = datetime.now(timezone.utc)
        
        # Validate parent task if specified
        if task_data.parent_task_id:
            parent_task = await self.get_task(task_data.parent_task_id, developer_id)
            if not parent_task:
                raise ValueError("Parent task not found")
        
        task_dict = {
            "id": task_id,
            "created_by": developer_id,
            "created_at": now,
            "updated_at": now,
            **task_data.model_dump(exclude_unset=True)
        }
        
        # Store in Firestore
        await firestore_service.create_document(self.collection_name, task_id, task_dict)
        
        # Return enhanced task response
        return await self._build_task_response(task_dict)
    
    async def get_task(self, task_id: str, developer_id: str) -> Optional[TaskResponse]:
        """
        Get a task by ID.
        
        Args:
            task_id: Task ID
            developer_id: Developer ID for authorization
            
        Returns:
            Task response or None if not found
        """
        task_doc = await firestore_service.get_document(self.collection_name, task_id)
        
        if not task_doc or task_doc.get("created_by") != developer_id:
            return None
        
        return await self._build_task_response(task_doc)
    
    async def get_task_hierarchy(self, task_id: str, developer_id: str) -> Optional[TaskHierarchyResponse]:
        """
        Get complete task hierarchy starting from a root task.
        
        Args:
            task_id: Root task ID
            developer_id: Developer ID for authorization
            
        Returns:
            Complete task hierarchy or None if not found
        """
        root_task = await self.get_task(task_id, developer_id)
        if not root_task:
            return None
        
        # Build complete hierarchy
        task_with_subtasks = await self._load_task_hierarchy(root_task, developer_id)
        
        # Calculate hierarchy statistics
        total_subtasks = self._count_total_subtasks(task_with_subtasks)
        max_depth = self._calculate_max_depth(task_with_subtasks)
        completion_summary = self._calculate_completion_summary(task_with_subtasks)
        
        return TaskHierarchyResponse(
            task=task_with_subtasks,
            total_subtasks=total_subtasks,
            max_depth=max_depth,
            completion_summary=completion_summary
        )
    
    async def create_subtask(self, parent_id: str, subtask_data: SubtaskCreate, developer_id: str) -> TaskResponse:
        """
        Create a subtask under a parent task.
        
        Args:
            parent_id: Parent task ID
            subtask_data: Subtask creation data
            developer_id: Developer ID
            
        Returns:
            Created subtask response
        """
        # Verify parent task exists and belongs to developer
        parent_task = await self.get_task(parent_id, developer_id)
        if not parent_task:
            raise ValueError("Parent task not found")
        
        # Create task data from subtask data
        task_create = TaskCreate(
            **subtask_data.model_dump(),
            parent_task_id=parent_id
        )
        
        return await self.create_task(task_create, developer_id)
    
    async def update_task(self, task_id: str, task_data: TaskUpdate, developer_id: str) -> Optional[TaskResponse]:
        """
        Update a task.
        
        Args:
            task_id: Task ID
            task_data: Task update data
            developer_id: Developer ID for authorization
            
        Returns:
            Updated task response or None if not found
        """
        # Get existing task
        existing_task = await firestore_service.get_document(self.collection_name, task_id)
        if not existing_task or existing_task.get("created_by") != developer_id:
            return None
        
        # Prepare update data
        update_data = task_data.model_dump(exclude_unset=True)
        update_data["updated_at"] = datetime.now(timezone.utc)
        
        # Handle completion status updates
        if task_data.status == TaskStatus.COMPLETED and existing_task.get("status") != TaskStatus.COMPLETED:
            update_data["completed_at"] = datetime.now(timezone.utc)
            update_data["completion_percentage"] = 100
        
        # Update in Firestore
        await firestore_service.update_document(self.collection_name, task_id, update_data)
        
        # Get updated task
        updated_task = await firestore_service.get_document(self.collection_name, task_id)
        return await self._build_task_response(updated_task)
    
    async def delete_task(self, task_id: str, developer_id: str, cascade: bool = False) -> bool:
        """
        Delete a task and optionally its subtasks.
        
        Args:
            task_id: Task ID
            developer_id: Developer ID for authorization
            cascade: Whether to delete subtasks as well
            
        Returns:
            True if deleted successfully
        """
        # Get task to verify ownership
        task = await self.get_task(task_id, developer_id)
        if not task:
            return False
        
        if cascade:
            # Delete all subtasks recursively
            await self._delete_task_hierarchy(task_id, developer_id)
        else:
            # Check if task has subtasks
            subtasks = await self._get_direct_subtasks(task_id, developer_id)
            if subtasks:
                raise ValueError("Cannot delete task with subtasks. Use cascade=true to delete all subtasks.")
        
        # Delete the task
        await firestore_service.delete_document(self.collection_name, task_id)
        return True
    
    async def move_task(self, task_id: str, move_data: TaskMoveRequest, developer_id: str) -> Optional[TaskResponse]:
        """
        Move a task to a different parent or position in hierarchy.
        
        Args:
            task_id: Task ID to move
            move_data: Move operation data
            developer_id: Developer ID for authorization
            
        Returns:
            Updated task response or None if not found
        """
        # Get task to verify ownership
        task = await self.get_task(task_id, developer_id)
        if not task:
            return None
        
        # Validate new parent if specified
        if move_data.new_parent_id:
            # Prevent circular dependencies
            if await self._would_create_cycle(task_id, move_data.new_parent_id, developer_id):
                raise ValueError("Cannot move task: would create circular dependency")
            
            # Verify new parent exists
            parent_task = await self.get_task(move_data.new_parent_id, developer_id)
            if not parent_task:
                raise ValueError("New parent task not found")
        
        # Update parent reference
        update_data = {
            "parent_task_id": move_data.new_parent_id,
            "updated_at": datetime.now(timezone.utc)
        }
        
        await firestore_service.update_document(self.collection_name, task_id, update_data)
        
        return await self.get_task(task_id, developer_id)
    
    async def list_tasks(
        self, 
        developer_id: str,
        parent_id: Optional[str] = None,
        status: Optional[TaskStatus] = None,
        priority: Optional[TaskPriority] = None,
        include_subtasks: bool = False,
        page: int = 1,
        page_size: int = 20
    ) -> Dict[str, Any]:
        """
        List tasks with filtering and pagination.
        
        Args:
            developer_id: Developer ID for authorization
            parent_id: Filter by parent task ID (None for root tasks)
            status: Filter by task status
            priority: Filter by task priority
            include_subtasks: Whether to include subtask hierarchies
            page: Page number
            page_size: Items per page
            
        Returns:
            Paginated task list with metadata
        """
        # Build query filters
        filters: List[Tuple[str, str, Any]] = [("created_by", "==", developer_id)]
        
        if parent_id is not None:
            filters.append(("parent_task_id", "==", parent_id))
        else:
            # For root tasks, parent_task_id should be None or empty
            filters.append(("parent_task_id", "==", None))
        
        if status:
            filters.append(("status", "==", status.value))
        
        if priority:
            filters.append(("priority", "==", priority.value))
        
        # Get paginated results
        offset = (page - 1) * page_size
        
        # Get tasks from Firestore
        tasks_docs = await firestore_service.query_documents(
            self.collection_name,
            filters=filters,
            order_by=[("created_at", "desc")],
            limit=page_size,
            offset=offset
        )
        
        # Build task responses
        tasks = []
        for task_doc in tasks_docs:
            task_response = await self._build_task_response(task_doc)
            
            if include_subtasks:
                task_response = await self._load_task_hierarchy(task_response, developer_id)
            
            tasks.append(task_response)
        
        # Get total count for pagination
        total_count = await firestore_service.count_documents(self.collection_name, filters)
        total_pages = (total_count + page_size - 1) // page_size
        
        return {
            "tasks": tasks,
            "total_count": total_count,
            "page": page,
            "page_size": page_size,
            "total_pages": total_pages
        }
    
    async def bulk_update_tasks(self, task_ids: List[str], update_data: TaskUpdate, developer_id: str) -> List[TaskResponse]:
        """
        Bulk update multiple tasks.
        
        Args:
            task_ids: List of task IDs to update
            update_data: Update data to apply
            developer_id: Developer ID for authorization
            
        Returns:
            List of updated task responses
        """
        updated_tasks = []
        
        for task_id in task_ids:
            updated_task = await self.update_task(task_id, update_data, developer_id)
            if updated_task:
                updated_tasks.append(updated_task)
        
        return updated_tasks
    
    # Private helper methods
    
    async def _build_task_response(self, task_dict: Dict[str, Any]) -> TaskResponse:
        """Build enhanced TaskResponse with computed fields."""
        # Calculate computed fields
        is_overdue = False
        is_due_today = False
        
        if task_dict.get("due_date") and task_dict.get("status") != TaskStatus.COMPLETED:
            due_date = task_dict["due_date"]
            if isinstance(due_date, str):
                due_date = datetime.fromisoformat(due_date.replace('Z', '+00:00'))
            
            now = datetime.now(timezone.utc)
            is_overdue = due_date < now
            is_due_today = due_date.date() == now.date()
        
        # Get subtask count
        subtasks = await self._get_direct_subtasks(task_dict["id"], task_dict["created_by"])
        subtask_count = len(subtasks)
        has_subtasks = subtask_count > 0
        
        # Calculate overall completion percentage
        overall_completion = task_dict.get("completion_percentage", 0)
        if has_subtasks:
            subtask_completions = [s.get("completion_percentage", 0) for s in subtasks]
            overall_completion = (overall_completion + sum(subtask_completions) / len(subtask_completions)) / 2
        
        return TaskResponse(
            **task_dict,
            subtasks=[],  # Will be populated separately if needed
            subtask_count=subtask_count,
            has_subtasks=has_subtasks,
            depth_level=0,  # Will be calculated in hierarchy loading
            overall_completion_percentage=overall_completion,
            is_overdue=is_overdue,
            is_due_today=is_due_today
        )
    
    async def _get_direct_subtasks(self, parent_id: str, developer_id: str) -> List[Dict[str, Any]]:
        """Get direct subtasks of a parent task."""
        filters = [
            ("created_by", "==", developer_id),
            ("parent_task_id", "==", parent_id)
        ]
        
        return await firestore_service.query_documents(
            self.collection_name,
            filters=filters,
            order_by=[("created_at", "asc")]
        )
    
    async def _load_task_hierarchy(self, task: TaskResponse, developer_id: str, depth: int = 0) -> TaskResponse:
        """Recursively load complete task hierarchy."""
        subtask_docs = await self._get_direct_subtasks(task.id, developer_id)
        
        subtasks = []
        for subtask_doc in subtask_docs:
            subtask_response = await self._build_task_response(subtask_doc)
            subtask_response.depth_level = depth + 1
            
            # Recursively load subtasks
            subtask_with_children = await self._load_task_hierarchy(subtask_response, developer_id, depth + 1)
            subtasks.append(subtask_with_children)
        
        task.subtasks = subtasks
        task.depth_level = depth
        return task
    
    async def _delete_task_hierarchy(self, task_id: str, developer_id: str) -> None:
        """Recursively delete task and all its subtasks."""
        subtasks = await self._get_direct_subtasks(task_id, developer_id)
        
        # Delete all subtasks first
        for subtask in subtasks:
            await self._delete_task_hierarchy(subtask["id"], developer_id)
        
        # Delete the task itself
        await firestore_service.delete_document(self.collection_name, task_id)
    
    async def _would_create_cycle(self, task_id: str, new_parent_id: str, developer_id: str) -> bool:
        """Check if moving a task would create a circular dependency."""
        current_id = new_parent_id
        
        while current_id:
            if current_id == task_id:
                return True
            
            current_task = await self.get_task(current_id, developer_id)
            if not current_task:
                break
            
            current_id = current_task.parent_task_id
        
        return False
    
    def _count_total_subtasks(self, task: TaskResponse) -> int:
        """Count total number of subtasks at all levels."""
        count = len(task.subtasks)
        for subtask in task.subtasks:
            count += self._count_total_subtasks(subtask)
        return count
    
    def _calculate_max_depth(self, task: TaskResponse) -> int:
        """Calculate maximum depth in the task hierarchy."""
        if not task.subtasks:
            return 0
        
        max_child_depth = max(self._calculate_max_depth(subtask) for subtask in task.subtasks)
        return max_child_depth + 1
    
    def _calculate_completion_summary(self, task: TaskResponse) -> Dict[str, Any]:
        """Calculate completion statistics for the hierarchy."""
        total_tasks = 1 + self._count_total_subtasks(task)
        completed_tasks = 0
        in_progress_tasks = 0
        todo_tasks = 0
        
        def count_by_status(t: TaskResponse):
            nonlocal completed_tasks, in_progress_tasks, todo_tasks
            
            if t.status == TaskStatus.COMPLETED:
                completed_tasks += 1
            elif t.status == TaskStatus.IN_PROGRESS:
                in_progress_tasks += 1
            else:
                todo_tasks += 1
            
            for subtask in t.subtasks:
                count_by_status(subtask)
        
        count_by_status(task)
        
        return {
            "total": total_tasks,
            "completed": completed_tasks,
            "in_progress": in_progress_tasks,
            "todo": todo_tasks,
            "completion_rate": round((completed_tasks / total_tasks) * 100, 2) if total_tasks > 0 else 0
        }


# Global task service instance
task_service = TaskService()