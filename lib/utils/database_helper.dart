import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static const String _databaseName = 'checklist_app.db';
  static const int _databaseVersion = 3;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    if (oldVersion < 2) {
      // Migration from version 1 to 2: rename reminderDateTime to reminderTime
      try {
        await db.execute(
          'ALTER TABLE tasks RENAME COLUMN reminderDateTime TO reminderTime',
        );
      } catch (e) {
        // If column doesn't exist or rename fails, recreate the table
        await db.execute('DROP TABLE IF EXISTS tasks');
        await _createTables(db);
      }
    }

    if (oldVersion < 3) {
      // Migration from version 2 to 3: add githubRepoId column and update schema
      try {
        await db.execute('ALTER TABLE tasks ADD COLUMN githubRepoId TEXT');
        await db.execute(
          'ALTER TABLE tasks ADD COLUMN estimatedMinutes INTEGER',
        );
        await db.execute('ALTER TABLE tasks ADD COLUMN actualMinutes INTEGER');
        await db.execute('ALTER TABLE tasks ADD COLUMN createdBy TEXT');
        await db.execute('ALTER TABLE tasks ADD COLUMN attachments TEXT');
        await db.execute('ALTER TABLE tasks ADD COLUMN subtasks TEXT');
      } catch (e) {
        // If migration fails, recreate the table
        await db.execute('DROP TABLE IF EXISTS tasks');
        await _createTables(db);
      }
    }

    if (oldVersion < newVersion) {
      await _createTables(db);
    }
  }

  Future<void> _createTables(Database db) async {
    // Create tasks table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        status TEXT NOT NULL,
        priority TEXT NOT NULL,
        dueDate TEXT,
        reminderTime TEXT,
        tags TEXT,
        location TEXT,
        githubIssueUrl TEXT,
        githubRepoId TEXT,
        calendarEventId TEXT,
        attachments TEXT,
        subtasks TEXT,
        parentTaskId TEXT,
        isRecurring INTEGER DEFAULT 0,
        recurrencePattern TEXT,
        estimatedMinutes INTEGER,
        actualMinutes INTEGER,
        completionPercentage INTEGER DEFAULT 0,
        createdBy TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        completedAt TEXT,
        metadata TEXT
      )
    ''');

    // Create notes table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        format TEXT DEFAULT 'markdown',
        tags TEXT,
        color TEXT DEFAULT '',
        isPinned INTEGER DEFAULT 0,
        isArchived INTEGER DEFAULT 0,
        isFavorite INTEGER DEFAULT 0,
        sharing TEXT,
        attachments TEXT,
        revisions TEXT,
        parentNoteId TEXT,
        childNoteIds TEXT,
        userId TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        lastViewedAt TEXT,
        metadata TEXT
      )
    ''');

    // Create categories table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        color TEXT DEFAULT 'blue',
        icon TEXT DEFAULT 'default',
        isDefault INTEGER DEFAULT 0,
        isArchived INTEGER DEFAULT 0,
        sharing TEXT,
        parentCategoryId TEXT,
        childCategoryIds TEXT,
        userId TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        sortOrder INTEGER DEFAULT 0,
        metadata TEXT
      )
    ''');

    // Create users table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        displayName TEXT,
        photoUrl TEXT,
        phoneNumber TEXT,
        primaryProvider TEXT NOT NULL,
        connectedAccounts TEXT,
        preferences TEXT,
        createdAt TEXT NOT NULL,
        lastLoginAt TEXT,
        isEmailVerified INTEGER DEFAULT 0,
        isPhoneVerified INTEGER DEFAULT 0,
        metadata TEXT
      )
    ''');

    // Create workspaces table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS workspaces (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        iconUrl TEXT,
        coverImageUrl TEXT,
        theme TEXT,
        integrations TEXT,
        members TEXT,
        ownerId TEXT NOT NULL,
        isPersonal INTEGER DEFAULT 0,
        isArchived INTEGER DEFAULT 0,
        taskIds TEXT,
        noteIds TEXT,
        categoryIds TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        lastAccessedAt TEXT,
        sortOrder INTEGER DEFAULT 0,
        metadata TEXT
      )
    ''');

    // Create indexes for better performance
    await _createIndexes(db);
  }

  Future<void> _createIndexes(Database db) async {
    // Task indexes - updated for new schema
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_tasks_priority ON tasks(priority)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_tasks_dueDate ON tasks(dueDate)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_tasks_createdAt ON tasks(createdAt)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_tasks_parentTaskId ON tasks(parentTaskId)',
    );

    // Note indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_notes_userId ON notes(userId)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_notes_createdAt ON notes(createdAt)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_notes_isPinned ON notes(isPinned)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_notes_isArchived ON notes(isArchived)',
    );

    // Category indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_categories_userId ON categories(userId)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_categories_parentCategoryId ON categories(parentCategoryId)',
    );

    // User indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)',
    );

    // Workspace indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_workspaces_ownerId ON workspaces(ownerId)',
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // Utility methods for JSON handling
  static String encodeJson(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List || value is Map) {
      return value
          .toString(); // For now, simple toString - can be improved with proper JSON encoding
    }
    return value.toString();
  }

  static List<String> decodeStringList(String? value) {
    if (value == null || value.isEmpty) return [];
    // Simple parsing - can be improved with proper JSON decoding
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static Map<String, dynamic> decodeStringMap(String? value) {
    if (value == null || value.isEmpty) return {};
    // Simple parsing - can be improved with proper JSON decoding
    return {};
  }

  // Backup and restore methods
  Future<String> backup() async {
    // final db = await database;
    // Implementation for backup
    return 'Backup functionality to be implemented';
  }

  Future<void> restore(String backupData) async {
    // Implementation for restore
  }

  // Migration helper methods
  Future<void> resetDatabase() async {
    await deleteDatabase();
    _database = await _initDatabase();
  }

  Future<bool> tableExists(String tableName) async {
    final db = await database;
    final result = await db.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', tableName],
    );
    return result.isNotEmpty;
  }

  Future<List<String>> getTableNames() async {
    final db = await database;
    final result = await db.query(
      'sqlite_master',
      columns: ['name'],
      where: 'type = ?',
      whereArgs: ['table'],
    );
    return result.map((row) => row['name'] as String).toList();
  }
}
