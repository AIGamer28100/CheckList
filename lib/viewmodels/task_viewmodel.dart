import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../utils/database_helper.dart';

// Provider for TaskRepository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(DatabaseHelper());
});

// Provider for TaskViewModel
final taskViewModelProvider = ChangeNotifierProvider<TaskViewModel>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskViewModel(repository);
});

// Provider for specific task lists
final allTasksProvider = FutureProvider<List<Task>>((ref) {
  final viewModel = ref.watch(taskViewModelProvider);
  return viewModel.getAllTasks();
});

final overdueTasksProvider = FutureProvider<List<Task>>((ref) {
  final viewModel = ref.watch(taskViewModelProvider);
  return viewModel.getOverdueTasks();
});

final todayTasksProvider = FutureProvider<List<Task>>((ref) {
  final viewModel = ref.watch(taskViewModelProvider);
  return viewModel.getTasksDueToday();
});

final completedTasksProvider = FutureProvider<List<Task>>((ref) {
  final viewModel = ref.watch(taskViewModelProvider);
  return viewModel.getCompletedTasks();
});

/// TaskViewModel handles all business logic for task management
class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;

  // Loading states
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  // Error handling
  String? _errorMessage;

  // Data state
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  Task? _selectedTask;

  // Filter and sort state
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  String? _categoryFilter;
  String? _searchQuery;
  String _sortBy = 'createdAt';
  bool _sortAscending = false;

  // Constructor
  TaskViewModel(this._repository) {
    _loadInitialData();
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  List<Task> get tasks => _filteredTasks.isEmpty ? _tasks : _filteredTasks;
  Task? get selectedTask => _selectedTask;

  TaskStatus? get statusFilter => _statusFilter;
  TaskPriority? get priorityFilter => _priorityFilter;
  String? get categoryFilter => _categoryFilter;
  String? get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;

  // Statistics
  int get totalTasks => _tasks.length;
  int get completedTasks =>
      _tasks.where((task) => task.status == TaskStatus.completed).length;
  int get pendingTasks =>
      _tasks.where((task) => task.status == TaskStatus.todo).length;
  int get inProgressTasks =>
      _tasks.where((task) => task.status == TaskStatus.inProgress).length;
  int get overdueTasks => _tasks.where((task) => task.isOverdue).length;

  double get completionPercentage {
    if (_tasks.isEmpty) return 0.0;
    return (completedTasks / totalTasks) * 100;
  }

  // Public methods

  /// Load initial data
  Future<void> _loadInitialData() async {
    await loadTasks();
  }

  /// Load all tasks
  Future<void> loadTasks() async {
    await _executeWithLoading(() async {
      _tasks = await _repository.getAll();
      _applyFiltersAndSort();
    });
  }

  /// Get all tasks (for providers)
  Future<List<Task>> getAllTasks() async {
    return await _repository.getAll();
  }

  /// Get overdue tasks
  Future<List<Task>> getOverdueTasks() async {
    return await _repository.getOverdueTasks();
  }

  /// Get tasks due today
  Future<List<Task>> getTasksDueToday() async {
    return await _repository.getTasksDueToday();
  }

  /// Get completed tasks
  Future<List<Task>> getCompletedTasks() async {
    return await _repository.getCompletedTasks();
  }

  /// Create a new task
  Future<Task?> createTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    DateTime? reminderTime,
    List<String> tags = const [],
    String? location,
    int? estimatedMinutes,
    required String createdBy,
  }) async {
    Task? createdTask;

    await _executeWithCreating(() async {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description ?? '',
        status: TaskStatus.todo,
        priority: priority,
        dueDate: dueDate,
        reminderTime: reminderTime,
        tags: tags,
        location: location,
        estimatedMinutes: estimatedMinutes,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      createdTask = await _repository.create(task);
      await loadTasks(); // Refresh the list
    });

    return createdTask;
  }

  /// Update an existing task
  Future<Task?> updateTask(Task task) async {
    Task? updatedTask;

    await _executeWithUpdating(() async {
      final taskWithUpdatedTime = task.copyWith(updatedAt: DateTime.now());
      updatedTask = await _repository.update(taskWithUpdatedTime);
      await loadTasks(); // Refresh the list
    });

    return updatedTask;
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    await _executeWithDeleting(() async {
      await _repository.delete(taskId);
      await loadTasks(); // Refresh the list
    });
  }

  /// Mark task as completed
  Future<void> markTaskCompleted(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final completedTask = task.markAsCompleted();
    await updateTask(completedTask);
  }

  /// Update task progress
  Future<void> updateTaskProgress(String taskId, int progress) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updatedTask = task.updateProgress(progress);
    await updateTask(updatedTask);
  }

  /// Toggle task favorite status (using metadata for now since isFavorite doesn't exist)
  Future<void> toggleTaskFavorite(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final currentFavorite = task.metadata['isFavorite'] ?? false;
    final updatedMetadata = Map<String, dynamic>.from(task.metadata);
    updatedMetadata['isFavorite'] = !currentFavorite;

    final updatedTask = task.copyWith(
      metadata: updatedMetadata,
      updatedAt: DateTime.now(),
    );
    await updateTask(updatedTask);
  }

  /// Duplicate a task
  Future<Task?> duplicateTask(String taskId, String createdBy) async {
    final originalTask = _tasks.firstWhere((t) => t.id == taskId);

    return await createTask(
      title: '${originalTask.title} (Copy)',
      description: originalTask.description,
      priority: originalTask.priority,
      dueDate: originalTask.dueDate,
      reminderTime: originalTask.reminderTime,
      tags: originalTask.tags,
      location: originalTask.location,
      estimatedMinutes: originalTask.estimatedMinutes,
      createdBy: createdBy,
    );
  }

  /// Search tasks
  Future<void> searchTasks(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredTasks = [];
    } else {
      await _executeWithLoading(() async {
        _filteredTasks = await _repository.search(query);
      });
    }

    notifyListeners();
  }

  /// Apply filters
  void applyFilters({
    TaskStatus? status,
    TaskPriority? priority,
    String? categoryId,
  }) {
    _statusFilter = status;
    _priorityFilter = priority;
    _categoryFilter = categoryId;

    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Clear filters
  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    _categoryFilter = null;
    _searchQuery = null;

    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Sort tasks
  void sortTasks(String sortBy, {bool ascending = true}) {
    _sortBy = sortBy;
    _sortAscending = ascending;

    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Select a task
  void selectTask(Task? task) {
    _selectedTask = task;
    notifyListeners();
  }

  /// Get tasks by category
  Future<List<Task>> getTasksByCategory(String categoryId) async {
    return await _repository.getByCategoryId(categoryId);
  }

  /// Get tasks by status
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    return await _repository.getByStatus(status);
  }

  /// Get tasks by priority
  Future<List<Task>> getTasksByPriority(TaskPriority priority) async {
    return await _repository.getByPriority(priority);
  }

  /// Get recent tasks
  Future<List<Task>> getRecentTasks() async {
    return await _repository.getRecentTasks();
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadTasks();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Private helper methods

  void _applyFiltersAndSort() {
    List<Task> filtered = List.from(_tasks);

    // Apply status filter
    if (_statusFilter != null) {
      filtered = filtered
          .where((task) => task.status == _statusFilter)
          .toList();
    }

    // Apply priority filter
    if (_priorityFilter != null) {
      filtered = filtered
          .where((task) => task.priority == _priorityFilter)
          .toList();
    }

    // Apply category filter (using metadata for now)
    if (_categoryFilter != null) {
      filtered = filtered
          .where((task) => task.metadata['categoryId'] == _categoryFilter)
          .toList();
    }

    // Sort tasks
    filtered.sort((a, b) {
      dynamic aValue, bValue;

      switch (_sortBy) {
        case 'title':
          aValue = a.title.toLowerCase();
          bValue = b.title.toLowerCase();
          break;
        case 'dueDate':
          aValue = a.dueDate ?? DateTime(2100);
          bValue = b.dueDate ?? DateTime(2100);
          break;
        case 'priority':
          aValue = a.priority.index;
          bValue = b.priority.index;
          break;
        case 'status':
          aValue = a.status.index;
          bValue = b.status.index;
          break;
        case 'createdAt':
        default:
          aValue = a.createdAt;
          bValue = b.createdAt;
          break;
      }

      final comparison = aValue.compareTo(bValue);
      return _sortAscending ? comparison : -comparison;
    });

    _filteredTasks = filtered;
  }

  Future<void> _executeWithLoading(Future<void> Function() operation) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await operation();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _executeWithCreating(Future<void> Function() operation) async {
    try {
      _isCreating = true;
      _errorMessage = null;
      notifyListeners();

      await operation();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<void> _executeWithUpdating(Future<void> Function() operation) async {
    try {
      _isUpdating = true;
      _errorMessage = null;
      notifyListeners();

      await operation();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> _executeWithDeleting(Future<void> Function() operation) async {
    try {
      _isDeleting = true;
      _errorMessage = null;
      notifyListeners();

      await operation();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }
}
