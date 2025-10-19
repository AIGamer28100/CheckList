import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

import '../repositories/firebase_task_repository.dart';
import '../repositories/base_repository.dart';
import '../utils/database_helper.dart';

/// Configuration for data storage backend
enum StorageBackend { sqlite, firebase }

/// Provider for storage backend configuration
final storageBackendProvider = StateProvider<StorageBackend>((ref) {
  // Default to Firebase for new installations
  // Could be configured via SharedPreferences for user preference
  return StorageBackend.firebase;
});

/// Provider for the appropriate task repository based on backend choice
final taskRepositoryProvider =
    Provider<WorkspaceScopedRepository<Task, String>>((ref) {
      final backend = ref.watch(storageBackendProvider);

      switch (backend) {
        case StorageBackend.sqlite:
          return TaskRepository(DatabaseHelper());
        case StorageBackend.firebase:
          try {
            return FirebaseTaskRepository();
          } catch (e) {
            // If Firebase is not available, fallback to SQLite
            debugPrint(
              'Firebase repository failed, falling back to SQLite: $e',
            );
            return TaskRepository(DatabaseHelper());
          }
      }
    });

/// Provider for TaskViewModel that works with any repository
final taskViewModelProvider = ChangeNotifierProvider<UniversalTaskViewModel>((
  ref,
) {
  final repository = ref.watch(taskRepositoryProvider);
  return UniversalTaskViewModel(repository);
});

/// Providers for specific task lists (updated to work with both backends)
final allTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getAll();
});

final overdueTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);

  if (repository is FirebaseTaskRepository) {
    return await repository.getOverdue();
  } else if (repository is TaskRepository) {
    // For SQLite, we need to implement the overdue logic
    final allTasks = await repository.getAll();
    final now = DateTime.now();
    return allTasks
        .where(
          (task) =>
              task.dueDate != null &&
              task.dueDate!.isBefore(now) &&
              task.status != TaskStatus.completed,
        )
        .toList();
  }
  return [];
});

final todayTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);

  if (repository is FirebaseTaskRepository) {
    return await repository.getDueToday();
  } else if (repository is TaskRepository) {
    // For SQLite, we need to implement the due today logic
    final allTasks = await repository.getAll();
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return allTasks
        .where(
          (task) =>
              task.dueDate != null &&
              task.dueDate!.isAfter(startOfDay) &&
              task.dueDate!.isBefore(endOfDay),
        )
        .toList();
  }
  return [];
});

final completedTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);

  if (repository is FirebaseTaskRepository) {
    return await repository.getCompleted();
  } else if (repository is TaskRepository) {
    // For SQLite, filter completed tasks
    final allTasks = await repository.getAll();
    return allTasks
        .where((task) => task.status == TaskStatus.completed)
        .toList();
  }
  return [];
});

/// Stream provider for real-time updates (Firebase only)
final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);

  if (repository is FirebaseTaskRepository) {
    return repository.getTasksStream();
  } else {
    // For SQLite, we can't provide real-time updates, so we return a single snapshot
    return Stream.fromFuture(repository.getAll());
  }
});

/// Universal TaskViewModel that works with any repository backend
class UniversalTaskViewModel extends ChangeNotifier {
  final WorkspaceScopedRepository<Task, String> _repository;

  UniversalTaskViewModel(this._repository);

  // Loading states
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  // Data
  List<Task> _tasks = [];

  // Error handling
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;
  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _setLoading(true);
    _clearError();

    try {
      _tasks = await _repository.getAll();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load tasks: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createTask(Task task) async {
    _setCreating(true);
    _clearError();

    try {
      final createdTask = await _repository.create(task);
      _tasks.insert(0, createdTask);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create task: $e');
      rethrow; // Re-throw so UI can handle it
    } finally {
      _setCreating(false);
    }
  }

  Future<void> updateTask(Task task) async {
    _setUpdating(true);
    _clearError();

    try {
      final updatedTask = await _repository.update(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update task: $e');
      rethrow;
    } finally {
      _setUpdating(false);
    }
  }

  Future<void> deleteTask(String taskId) async {
    _setDeleting(true);
    _clearError();

    try {
      await _repository.delete(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete task: $e');
      rethrow;
    } finally {
      _setDeleting(false);
    }
  }

  Future<void> completeTask(String taskId) async {
    _setUpdating(true);
    _clearError();

    try {
      Task? taskToComplete = _tasks.firstWhere((task) => task.id == taskId);

      if (_repository is FirebaseTaskRepository) {
        // Use Firebase-specific complete method
        final completedTask = await _repository.completeTask(taskId);
        final index = _tasks.indexWhere((t) => t.id == taskId);
        if (index != -1) {
          _tasks[index] = completedTask;
          notifyListeners();
        }
      } else {
        // For other repositories, update the task manually
        final completedTask = taskToComplete.copyWith(
          status: TaskStatus.completed,
          completedAt: DateTime.now(),
          completionPercentage: 100,
        );
        await updateTask(completedTask);
      }
    } catch (e) {
      _setError('Failed to complete task: $e');
      rethrow;
    } finally {
      _setUpdating(false);
    }
  }

  Future<List<Task>> searchTasks(String query) async {
    _clearError();

    try {
      return await _repository.search(query);
    } catch (e) {
      _setError('Failed to search tasks: $e');
      return [];
    }
  }

  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
    notifyListeners();
  }

  void _setDeleting(bool deleting) {
    _isDeleting = deleting;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

/// Provider for migration service
final migrationServiceProvider = Provider<MigrationService>((ref) {
  return MigrationService(ref);
});

/// Service to handle migration between storage backends
class MigrationService {
  final Ref _ref;

  MigrationService(this._ref);

  /// Migrate from SQLite to Firebase
  Future<bool> migrateToFirebase() async {
    try {
      // First, get all data from SQLite
      final sqliteRepository = TaskRepository(DatabaseHelper());
      final sqliteTasks = await sqliteRepository.getAll();

      if (sqliteTasks.isEmpty) {
        debugPrint('No tasks to migrate from SQLite');
        _switchToFirebase();
        return true;
      }

      // Get Firebase repository
      final firebaseRepository = FirebaseTaskRepository();

      // Migrate each task
      for (final task in sqliteTasks) {
        try {
          await firebaseRepository.create(task);
        } catch (e) {
          debugPrint('Failed to migrate task ${task.id}: $e');
          // Continue with other tasks
        }
      }

      // Switch to Firebase backend after successful migration
      _switchToFirebase();

      debugPrint(
        'Successfully migrated ${sqliteTasks.length} tasks to Firebase',
      );
      return true;
    } catch (e) {
      debugPrint('Migration failed: $e');
      return false;
    }
  }

  /// Switch storage backend
  void switchBackend(StorageBackend backend) {
    _ref.read(storageBackendProvider.notifier).state = backend;
  }

  void _switchToFirebase() {
    _ref.read(storageBackendProvider.notifier).state = StorageBackend.firebase;
  }
}
