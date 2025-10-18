import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Todo item model
class Todo {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  /// Create Todo from Firestore document
  factory Todo.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completed: data['completed'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  /// Convert Todo to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'userId': userId,
    };
  }

  /// Create a copy with modified fields
  Todo copyWith({
    String? title,
    String? description,
    bool? completed,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      userId: userId,
    );
  }
}

/// Firestore Service for Todo operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _todosCollection = 'todos';

  /// Get todos stream for a specific user
  Stream<List<Todo>> getTodosStream(String userId) {
    return _firestore
        .collection(_todosCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Todo.fromDocument(doc)).toList(),
        );
  }

  /// Add a new todo
  Future<String> addTodo({
    required String title,
    required String description,
    required String userId,
  }) async {
    try {
      DateTime now = DateTime.now();
      Todo todo = Todo(
        id: '', // Will be assigned by Firestore
        title: title,
        description: description,
        completed: false,
        createdAt: now,
        updatedAt: now,
        userId: userId,
      );

      DocumentReference docRef = await _firestore
          .collection(_todosCollection)
          .add(todo.toMap());

      return docRef.id;
    } catch (e) {
      debugPrint('Error adding todo: $e');
      rethrow;
    }
  }

  /// Update a todo
  Future<void> updateTodo(Todo todo) async {
    try {
      await _firestore
          .collection(_todosCollection)
          .doc(todo.id)
          .update(todo.toMap());
    } catch (e) {
      debugPrint('Error updating todo: $e');
      rethrow;
    }
  }

  /// Toggle todo completion status
  Future<void> toggleTodoCompletion(String todoId, bool completed) async {
    try {
      await _firestore.collection(_todosCollection).doc(todoId).update({
        'completed': completed,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      debugPrint('Error toggling todo completion: $e');
      rethrow;
    }
  }

  /// Delete a todo
  Future<void> deleteTodo(String todoId) async {
    try {
      await _firestore.collection(_todosCollection).doc(todoId).delete();
    } catch (e) {
      debugPrint('Error deleting todo: $e');
      rethrow;
    }
  }

  /// Get a single todo by ID
  Future<Todo?> getTodoById(String todoId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_todosCollection)
          .doc(todoId)
          .get();

      if (doc.exists) {
        return Todo.fromDocument(doc);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting todo: $e');
      rethrow;
    }
  }

  /// Delete all todos for a user (useful for account deletion)
  Future<void> deleteAllUserTodos(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_todosCollection)
          .where('userId', isEqualTo: userId)
          .get();

      WriteBatch batch = _firestore.batch();
      for (DocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Error deleting user todos: $e');
      rethrow;
    }
  }

  /// Get todos count for a user
  Future<int> getTodosCount(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_todosCollection)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint('Error getting todos count: $e');
      rethrow;
    }
  }

  /// Get completed todos count for a user
  Future<int> getCompletedTodosCount(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_todosCollection)
          .where('userId', isEqualTo: userId)
          .where('completed', isEqualTo: true)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint('Error getting completed todos count: $e');
      rethrow;
    }
  }
}
