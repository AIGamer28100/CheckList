import 'package:sqflite/sqflite.dart';
import '../models/task.dart';
import '../utils/database_helper.dart';
import 'base_repository.dart';

class TaskRepository implements WorkspaceScopedRepository<Task, String> {
  static const String tableName = 'tasks';

  final DatabaseHelper _databaseHelper;

  TaskRepository(this._databaseHelper);

  @override
  Future<List<Task>> getAll() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  @override
  Future<Task?> getById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Task.fromJson(maps.first);
  }

  @override
  Future<Task> create(Task task) async {
    final db = await _databaseHelper.database;
    final taskMap = task.toJson();

    await db.insert(
      tableName,
      taskMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return task;
  }

  @override
  Future<Task> update(Task task) async {
    final db = await _databaseHelper.database;
    final taskMap = task.toJson();

    await db.update(tableName, taskMap, where: 'id = ?', whereArgs: [task.id]);

    return task;
  }

  @override
  Future<void> delete(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<bool> exists(String id) async {
    final db = await _databaseHelper.database;
    final count = Sqflite.firstIntValue(
      await db.query(
        tableName,
        columns: ['COUNT(*)'],
        where: 'id = ?',
        whereArgs: [id],
      ),
    );

    return (count ?? 0) > 0;
  }

  @override
  Future<int> count() async {
    final db = await _databaseHelper.database;
    final count = Sqflite.firstIntValue(
      await db.query(tableName, columns: ['COUNT(*)']),
    );

    return count ?? 0;
  }

  @override
  Future<void> clear() async {
    final db = await _databaseHelper.database;
    await db.delete(tableName);
  }

  @override
  Future<List<Task>> search(String query) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'title LIKE ? OR description LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  @override
  Future<List<Task>> getPaginated({
    int offset = 0,
    int limit = 20,
    String? orderBy,
    bool ascending = true,
  }) async {
    final db = await _databaseHelper.database;
    final order = orderBy ?? 'createdAt';
    final direction = ascending ? 'ASC' : 'DESC';

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: '$order $direction',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  @override
  Future<List<Task>> getByFilter(Map<String, dynamic> filters) async {
    final db = await _databaseHelper.database;
    String where = '';
    List<dynamic> whereArgs = [];

    filters.forEach((key, value) {
      if (where.isNotEmpty) where += ' AND ';
      where += '$key = ?';
      whereArgs.add(value);
    });

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: where.isEmpty ? null : where,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  @override
  Future<List<Task>> createBatch(List<Task> tasks) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final task in tasks) {
      batch.insert(
        tableName,
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    return tasks;
  }

  @override
  Future<List<Task>> updateBatch(List<Task> tasks) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final task in tasks) {
      batch.update(
        tableName,
        task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    }

    await batch.commit(noResult: true);
    return tasks;
  }

  @override
  Future<void> deleteBatch(List<String> ids) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final id in ids) {
      batch.delete(tableName, where: 'id = ?', whereArgs: [id]);
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<Task>> getByUserId(String userId) async {
    return getByFilter({'userId': userId});
  }

  @override
  Future<int> countByUserId(String userId) async {
    final db = await _databaseHelper.database;
    final count = Sqflite.firstIntValue(
      await db.query(
        tableName,
        columns: ['COUNT(*)'],
        where: 'userId = ?',
        whereArgs: [userId],
      ),
    );

    return count ?? 0;
  }

  @override
  Future<void> deleteByUserId(String userId) async {
    final db = await _databaseHelper.database;
    await db.delete(tableName, where: 'userId = ?', whereArgs: [userId]);
  }

  @override
  Future<List<Task>> getByWorkspaceId(String workspaceId) async {
    return getByFilter({'workspaceId': workspaceId});
  }

  @override
  Future<int> countByWorkspaceId(String workspaceId) async {
    final db = await _databaseHelper.database;
    final count = Sqflite.firstIntValue(
      await db.query(
        tableName,
        columns: ['COUNT(*)'],
        where: 'workspaceId = ?',
        whereArgs: [workspaceId],
      ),
    );

    return count ?? 0;
  }

  @override
  Future<void> deleteByWorkspaceId(String workspaceId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      tableName,
      where: 'workspaceId = ?',
      whereArgs: [workspaceId],
    );
  }

  @override
  Future<List<Task>> getByUserAndWorkspace(
    String userId,
    String workspaceId,
  ) async {
    return getByFilter({'userId': userId, 'workspaceId': workspaceId});
  }

  // Additional task-specific methods

  /// Get tasks by status
  Future<List<Task>> getByStatus(TaskStatus status) async {
    return getByFilter({'status': status.name});
  }

  /// Get tasks by priority
  Future<List<Task>> getByPriority(TaskPriority priority) async {
    return getByFilter({'priority': priority.name});
  }

  /// Get tasks by category
  Future<List<Task>> getByCategoryId(String categoryId) async {
    return getByFilter({'categoryId': categoryId});
  }

  /// Get overdue tasks
  Future<List<Task>> getOverdueTasks() async {
    final db = await _databaseHelper.database;
    final now = DateTime.now().toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'dueDate < ? AND status != ?',
      whereArgs: [now, TaskStatus.completed.name],
      orderBy: 'dueDate ASC',
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  /// Get tasks due today
  Future<List<Task>> getTasksDueToday() async {
    final db = await _databaseHelper.database;
    final today = DateTime.now();
    final startOfDay = DateTime(
      today.year,
      today.month,
      today.day,
    ).toIso8601String();
    final endOfDay = DateTime(
      today.year,
      today.month,
      today.day,
      23,
      59,
      59,
    ).toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'dueDate >= ? AND dueDate <= ? AND status != ?',
      whereArgs: [startOfDay, endOfDay, TaskStatus.completed.name],
      orderBy: 'dueDate ASC',
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  /// Get completed tasks
  Future<List<Task>> getCompletedTasks() async {
    return getByStatus(TaskStatus.completed);
  }

  /// Get tasks with reminders
  Future<List<Task>> getTasksWithReminders() async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'reminderDateTime IS NOT NULL',
      orderBy: 'reminderDateTime ASC',
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  /// Get tasks by date range
  Future<List<Task>> getTasksByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'createdAt >= ? AND createdAt <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  /// Get recent tasks (last 7 days)
  Future<List<Task>> getRecentTasks() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return getTasksByDateRange(sevenDaysAgo, DateTime.now());
  }

  /// Sync tasks with GitHub issues
  Future<List<Task>> getGitHubLinkedTasks() async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'gitHubIssueUrl IS NOT NULL AND gitHubIssueUrl != ""',
      orderBy: 'updatedAt DESC',
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  /// Get tasks with calendar events
  Future<List<Task>> getCalendarLinkedTasks() async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'calendarEventId IS NOT NULL AND calendarEventId != ""',
      orderBy: 'updatedAt DESC',
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }
}
