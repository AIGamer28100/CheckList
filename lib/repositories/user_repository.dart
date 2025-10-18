import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../utils/database_helper.dart';
import 'base_repository.dart';
import 'dart:convert';

class UserRepository implements ExtendedRepository<User, String> {
  static const String tableName = 'users';

  final DatabaseHelper _databaseHelper;

  UserRepository(this._databaseHelper);

  @override
  Future<List<User>> getAll() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _mapToUser(map)).toList();
  }

  @override
  Future<User?> getById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _mapToUser(maps.first);
  }

  @override
  Future<User> create(User user) async {
    final db = await _databaseHelper.database;
    final userMap = _userToMap(user);

    await db.insert(
      tableName,
      userMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return user;
  }

  @override
  Future<User> update(User user) async {
    final db = await _databaseHelper.database;
    final userMap = _userToMap(user);

    await db.update(tableName, userMap, where: 'id = ?', whereArgs: [user.id]);

    return user;
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
  Future<List<User>> search(String query) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'email LIKE ? OR displayName LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _mapToUser(map)).toList();
  }

  @override
  Future<List<User>> getPaginated({
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

    return maps.map((map) => _mapToUser(map)).toList();
  }

  @override
  Future<List<User>> getByFilter(Map<String, dynamic> filters) async {
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

    return maps.map((map) => _mapToUser(map)).toList();
  }

  @override
  Future<List<User>> createBatch(List<User> users) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final user in users) {
      batch.insert(
        tableName,
        _userToMap(user),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    return users;
  }

  @override
  Future<List<User>> updateBatch(List<User> users) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final user in users) {
      batch.update(
        tableName,
        _userToMap(user),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }

    await batch.commit(noResult: true);
    return users;
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

  // Additional user-specific methods

  /// Get user by email
  Future<User?> getByEmail(String email) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _mapToUser(maps.first);
  }

  /// Get users by primary provider
  Future<List<User>> getByProvider(AuthProvider provider) async {
    return getByFilter({'primaryProvider': provider.name});
  }

  /// Get verified users
  Future<List<User>> getVerifiedUsers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'isEmailVerified = 1 OR isPhoneVerified = 1',
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _mapToUser(map)).toList();
  }

  /// Get users who logged in recently (last 30 days)
  Future<List<User>> getRecentlyActiveUsers() async {
    final db = await _databaseHelper.database;
    final thirtyDaysAgo = DateTime.now()
        .subtract(const Duration(days: 30))
        .toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'lastLoginAt > ?',
      whereArgs: [thirtyDaysAgo],
      orderBy: 'lastLoginAt DESC',
    );

    return maps.map((map) => _mapToUser(map)).toList();
  }

  /// Check if email exists
  Future<bool> emailExists(String email) async {
    final user = await getByEmail(email);
    return user != null;
  }

  /// Get users with GitHub connected
  Future<List<User>> getUsersWithGitHub() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'connectedAccounts LIKE ?',
      whereArgs: ['%github%'],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _mapToUser(map)).toList();
  }

  /// Get users with Google connected
  Future<List<User>> getUsersWithGoogle() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'connectedAccounts LIKE ?',
      whereArgs: ['%google%'],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _mapToUser(map)).toList();
  }

  // Helper methods for mapping between User and Map

  Map<String, dynamic> _userToMap(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'phoneNumber': user.phoneNumber,
      'primaryProvider': user.primaryProvider.name,
      'connectedAccounts': jsonEncode(
        user.connectedAccounts.map((account) => account.toJson()).toList(),
      ),
      'preferences': jsonEncode(user.preferences.toJson()),
      'createdAt': user.createdAt.toIso8601String(),
      'lastLoginAt': user.lastLoginAt?.toIso8601String(),
      'isEmailVerified': user.isEmailVerified ? 1 : 0,
      'isPhoneVerified': user.isPhoneVerified ? 1 : 0,
      'metadata': jsonEncode(user.metadata),
    };
  }

  User _mapToUser(Map<String, dynamic> map) {
    List<ConnectedAccount> connectedAccounts = [];
    try {
      final accountsJson = jsonDecode(map['connectedAccounts'] ?? '[]') as List;
      connectedAccounts = accountsJson
          .map(
            (account) =>
                ConnectedAccount.fromJson(account as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      // Handle parsing error gracefully
      connectedAccounts = [];
    }

    UserPreferences preferences;
    try {
      final preferencesJson =
          jsonDecode(map['preferences'] ?? '{}') as Map<String, dynamic>;
      preferences = UserPreferences.fromJson(preferencesJson);
    } catch (e) {
      // Handle parsing error gracefully
      preferences = const UserPreferences();
    }

    Map<String, dynamic> metadata;
    try {
      metadata = jsonDecode(map['metadata'] ?? '{}') as Map<String, dynamic>;
    } catch (e) {
      metadata = {};
    }

    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      primaryProvider: AuthProvider.values.firstWhere(
        (provider) => provider.name == map['primaryProvider'],
        orElse: () => AuthProvider.email,
      ),
      connectedAccounts: connectedAccounts,
      preferences: preferences,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastLoginAt: map['lastLoginAt'] != null
          ? DateTime.parse(map['lastLoginAt'] as String)
          : null,
      isEmailVerified: (map['isEmailVerified'] as int) == 1,
      isPhoneVerified: (map['isPhoneVerified'] as int) == 1,
      metadata: metadata,
    );
  }
}
