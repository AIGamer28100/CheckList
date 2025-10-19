import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

/// Firebase-based task service that replaces SQLite
class FirebaseTaskService {
  static final FirebaseTaskService _instance = FirebaseTaskService._internal();
  factory FirebaseTaskService() => _instance;
  FirebaseTaskService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Collection reference for tasks
  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      _firestore.collection('tasks');

  /// Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Create a new task
  Future<Task> createTask(Task task) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Create task with user ID
      final taskWithUser = task.copyWith(
        createdBy: _currentUserId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Convert to Firestore format
      final taskData = _taskToFirestore(taskWithUser);

      // Add to Firestore
      final docRef = await _tasksCollection.add(taskData);

      // Return task with Firestore document ID
      return taskWithUser.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  /// Get all tasks for current user
  Future<List<Task>> getAllTasks() async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final querySnapshot = await _tasksCollection
          .where('createdBy', isEqualTo: _currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => _firestoreToTask(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  /// Get tasks stream for real-time updates
  Stream<List<Task>> getTasksStream() {
    if (_currentUserId == null) {
      return Stream.error('User not authenticated');
    }

    return _tasksCollection
        .where('createdBy', isEqualTo: _currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _firestoreToTask(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Get task by ID
  Future<Task?> getTaskById(String taskId) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final doc = await _tasksCollection.doc(taskId).get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      // Check if task belongs to current user
      if (data['createdBy'] != _currentUserId) {
        throw Exception('Access denied');
      }

      return _firestoreToTask(doc.id, data);
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  /// Update a task
  Future<Task> updateTask(Task task) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Verify task belongs to current user
      final existingTask = await getTaskById(task.id);
      if (existingTask == null) {
        throw Exception('Task not found');
      }

      // Update task with new timestamp
      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      final taskData = _taskToFirestore(updatedTask);

      // Update in Firestore
      await _tasksCollection.doc(task.id).update(taskData);

      return updatedTask;
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Verify task belongs to current user
      final existingTask = await getTaskById(taskId);
      if (existingTask == null) {
        throw Exception('Task not found');
      }

      // Delete from Firestore
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  /// Mark task as completed
  Future<Task> completeTask(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw Exception('Task not found');
      }

      return await updateTask(
        task.copyWith(
          status: TaskStatus.completed,
          completedAt: DateTime.now(),
          completionPercentage: 100,
        ),
      );
    } catch (e) {
      throw Exception('Failed to complete task: $e');
    }
  }

  /// Get tasks by status
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final querySnapshot = await _tasksCollection
          .where('createdBy', isEqualTo: _currentUserId)
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => _firestoreToTask(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks by status: $e');
    }
  }

  /// Get tasks due today
  Future<List<Task>> getTasksDueToday() async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _tasksCollection
          .where('createdBy', isEqualTo: _currentUserId)
          .where(
            'dueDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('dueDate', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('dueDate')
          .get();

      return querySnapshot.docs
          .map((doc) => _firestoreToTask(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks due today: $e');
    }
  }

  /// Get overdue tasks
  Future<List<Task>> getOverdueTasks() async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now();

      final querySnapshot = await _tasksCollection
          .where('createdBy', isEqualTo: _currentUserId)
          .where('dueDate', isLessThan: Timestamp.fromDate(now))
          .where('status', whereIn: ['todo', 'in_progress'])
          .orderBy('dueDate')
          .get();

      return querySnapshot.docs
          .map((doc) => _firestoreToTask(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get overdue tasks: $e');
    }
  }

  /// Search tasks by title or description
  Future<List<Task>> searchTasks(String query) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Note: Firestore doesn't support full-text search natively
      // For production, consider using Algolia or Elasticsearch
      final querySnapshot = await _tasksCollection
          .where('createdBy', isEqualTo: _currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      final allTasks = querySnapshot.docs
          .map((doc) => _firestoreToTask(doc.id, doc.data()))
          .toList();

      // Filter on client side (not ideal for large datasets)
      return allTasks
          .where(
            (task) =>
                task.title.toLowerCase().contains(query.toLowerCase()) ||
                (task.description?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search tasks: $e');
    }
  }

  /// Convert Task to Firestore format
  Map<String, dynamic> _taskToFirestore(Task task) {
    final json = task.toJson();

    // Convert DateTime to Timestamp for Firestore
    if (json['createdAt'] != null) {
      json['createdAt'] = Timestamp.fromDate(DateTime.parse(json['createdAt']));
    }
    if (json['updatedAt'] != null) {
      json['updatedAt'] = Timestamp.fromDate(DateTime.parse(json['updatedAt']));
    }
    if (json['completedAt'] != null) {
      json['completedAt'] = Timestamp.fromDate(
        DateTime.parse(json['completedAt']),
      );
    }
    if (json['dueDate'] != null) {
      json['dueDate'] = Timestamp.fromDate(DateTime.parse(json['dueDate']));
    }
    if (json['reminderTime'] != null) {
      json['reminderTime'] = Timestamp.fromDate(
        DateTime.parse(json['reminderTime']),
      );
    }

    return json;
  }

  /// Convert Firestore data to Task
  Task _firestoreToTask(String id, Map<String, dynamic> data) {
    // Convert Timestamp back to DateTime
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] = (data['updatedAt'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
    if (data['completedAt'] is Timestamp) {
      data['completedAt'] = (data['completedAt'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
    if (data['dueDate'] is Timestamp) {
      data['dueDate'] = (data['dueDate'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
    if (data['reminderTime'] is Timestamp) {
      data['reminderTime'] = (data['reminderTime'] as Timestamp)
          .toDate()
          .toIso8601String();
    }

    // Set the document ID
    data['id'] = id;

    return Task.fromJson(data);
  }

  /// Batch operations for better performance
  Future<void> batchCreateTasks(List<Task> tasks) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final batch = _firestore.batch();

      for (final task in tasks) {
        final taskWithUser = task.copyWith(
          createdBy: _currentUserId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final docRef = _tasksCollection.doc();
        final taskData = _taskToFirestore(taskWithUser);
        batch.set(docRef, taskData);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch create tasks: $e');
    }
  }

  /// Sync local SQLite data to Firebase (for migration)
  Future<void> migrateFromSQLite(List<Task> sqliteTasks) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      debugPrint(
        'Migrating ${sqliteTasks.length} tasks from SQLite to Firebase...',
      );

      await batchCreateTasks(sqliteTasks);

      debugPrint('Migration completed successfully!');
    } catch (e) {
      throw Exception('Failed to migrate from SQLite: $e');
    }
  }
}
