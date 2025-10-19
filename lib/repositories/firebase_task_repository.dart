import '../models/task.dart';
import '../services/firebase_task_service.dart';
import 'base_repository.dart';

/// Firebase-based task repository that replaces SQLite implementation
class FirebaseTaskRepository
    implements WorkspaceScopedRepository<Task, String> {
  final FirebaseTaskService _firebaseTaskService = FirebaseTaskService();

  // Base Repository methods
  @override
  Future<List<Task>> getAll() async {
    return await _firebaseTaskService.getAllTasks();
  }

  @override
  Future<Task?> getById(String id) async {
    return await _firebaseTaskService.getTaskById(id);
  }

  @override
  Future<Task> create(Task task) async {
    return await _firebaseTaskService.createTask(task);
  }

  @override
  Future<Task> update(Task task) async {
    return await _firebaseTaskService.updateTask(task);
  }

  @override
  Future<void> delete(String id) async {
    await _firebaseTaskService.deleteTask(id);
  }

  @override
  Future<bool> exists(String id) async {
    final task = await getById(id);
    return task != null;
  }

  @override
  Future<int> count() async {
    final tasks = await getAll();
    return tasks.length;
  }

  @override
  Future<void> clear() async {
    // WARNING: This will delete all tasks for the current user
    final tasks = await getAll();
    for (final task in tasks) {
      await delete(task.id);
    }
  }

  // Extended Repository methods
  @override
  Future<List<Task>> search(String query) async {
    return await _firebaseTaskService.searchTasks(query);
  }

  @override
  Future<List<Task>> getPaginated({
    int offset = 0,
    int limit = 20,
    String? orderBy,
    bool ascending = true,
  }) async {
    final allTasks = await getAll();

    // Sort if orderBy is specified
    if (orderBy != null) {
      allTasks.sort((a, b) {
        dynamic aValue, bValue;
        switch (orderBy) {
          case 'title':
            aValue = a.title;
            bValue = b.title;
            break;
          case 'createdAt':
            aValue = a.createdAt;
            bValue = b.createdAt;
            break;
          case 'dueDate':
            aValue = a.dueDate ?? DateTime(2099, 12, 31);
            bValue = b.dueDate ?? DateTime(2099, 12, 31);
            break;
          case 'priority':
            aValue = a.priority.index;
            bValue = b.priority.index;
            break;
          default:
            aValue = a.createdAt;
            bValue = b.createdAt;
        }
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    }

    // Apply pagination
    final endIndex = (offset + limit).clamp(0, allTasks.length);
    return allTasks.sublist(offset.clamp(0, allTasks.length), endIndex);
  }

  @override
  Future<List<Task>> getByFilter(Map<String, dynamic> filters) async {
    final allTasks = await getAll();

    return allTasks.where((task) {
      for (final entry in filters.entries) {
        final key = entry.key;
        final value = entry.value;

        switch (key) {
          case 'status':
            if (task.status.name != value) return false;
            break;
          case 'priority':
            if (task.priority.name != value) return false;
            break;
          case 'completed':
            if ((task.status == TaskStatus.completed) != value) return false;
            break;
          case 'hasReminder':
            if ((task.reminderTime != null) != value) return false;
            break;
          case 'tag':
            if (!task.tags.contains(value)) return false;
            break;
        }
      }
      return true;
    }).toList();
  }

  @override
  Future<List<Task>> createBatch(List<Task> items) async {
    await _firebaseTaskService.batchCreateTasks(items);
    return items;
  }

  @override
  Future<List<Task>> updateBatch(List<Task> items) async {
    final updatedTasks = <Task>[];
    for (final task in items) {
      final updatedTask = await update(task);
      updatedTasks.add(updatedTask);
    }
    return updatedTasks;
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    for (final id in ids) {
      await delete(id);
    }
  }

  // User Scoped Repository methods
  @override
  Future<List<Task>> getByUserId(String userId) async {
    // Firebase service already filters by current user
    return await getAll();
  }

  @override
  Future<int> countByUserId(String userId) async {
    final tasks = await getByUserId(userId);
    return tasks.length;
  }

  @override
  Future<void> deleteByUserId(String userId) async {
    // This would delete all tasks for a user - use with extreme caution
    await clear();
  }

  // Workspace Scoped Repository methods
  @override
  Future<List<Task>> getByWorkspaceId(String workspaceId) async {
    final allTasks = await getAll();
    return allTasks
        .where((task) => task.metadata['workspaceId'] == workspaceId)
        .toList();
  }

  @override
  Future<int> countByWorkspaceId(String workspaceId) async {
    final tasks = await getByWorkspaceId(workspaceId);
    return tasks.length;
  }

  @override
  Future<void> deleteByWorkspaceId(String workspaceId) async {
    final tasks = await getByWorkspaceId(workspaceId);
    await deleteBatch(tasks.map((t) => t.id).toList());
  }

  @override
  Future<List<Task>> getByUserAndWorkspace(
    String userId,
    String workspaceId,
  ) async {
    final tasks = await getByWorkspaceId(workspaceId);
    return tasks.where((task) => task.createdBy == userId).toList();
  }

  // Additional convenience methods
  Future<List<Task>> getByCategory(String categoryId) async {
    final allTasks = await getAll();
    return allTasks
        .where((task) => task.metadata['categoryId'] == categoryId)
        .toList();
  }

  Future<List<Task>> getByPriority(TaskPriority priority) async {
    final allTasks = await getAll();
    return allTasks.where((task) => task.priority == priority).toList();
  }

  Future<List<Task>> getByStatus(TaskStatus status) async {
    return await _firebaseTaskService.getTasksByStatus(status);
  }

  Future<List<Task>> getByDateRange(DateTime start, DateTime end) async {
    final allTasks = await getAll();
    return allTasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isAfter(start) && task.dueDate!.isBefore(end);
    }).toList();
  }

  Future<List<Task>> getByTags(List<String> tags) async {
    final allTasks = await getAll();
    return allTasks.where((task) {
      return tags.any((tag) => task.tags.contains(tag));
    }).toList();
  }

  Future<List<Task>> getCompleted() async {
    return await _firebaseTaskService.getTasksByStatus(TaskStatus.completed);
  }

  Future<List<Task>> getPending() async {
    final todoTasks = await _firebaseTaskService.getTasksByStatus(
      TaskStatus.todo,
    );
    final inProgressTasks = await _firebaseTaskService.getTasksByStatus(
      TaskStatus.inProgress,
    );
    return [...todoTasks, ...inProgressTasks];
  }

  Future<List<Task>> getDueToday() async {
    return await _firebaseTaskService.getTasksDueToday();
  }

  Future<List<Task>> getOverdue() async {
    return await _firebaseTaskService.getOverdueTasks();
  }

  Future<List<Task>> getRecent(int limit) async {
    final allTasks = await getAll();
    allTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allTasks.take(limit).toList();
  }

  /// Get real-time stream of tasks
  Stream<List<Task>> getTasksStream() {
    return _firebaseTaskService.getTasksStream();
  }

  /// Complete a task
  Future<Task> completeTask(String taskId) async {
    return await _firebaseTaskService.completeTask(taskId);
  }

  /// Migration utility: Move data from SQLite to Firebase
  Future<void> migrateFromSQLite(List<Task> sqliteTasks) async {
    await _firebaseTaskService.migrateFromSQLite(sqliteTasks);
  }
}
