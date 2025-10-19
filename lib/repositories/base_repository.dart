/// Base repository interface for common CRUD operations
abstract class BaseRepository<T, ID> {
  /// Get all items
  Future<List<T>> getAll();

  /// Get item by ID
  Future<T?> getById(ID id);

  /// Create a new item
  Future<T> create(T item);

  /// Update an existing item
  Future<T> update(T item);

  /// Delete an item by ID
  Future<void> delete(ID id);

  /// Check if item exists
  Future<bool> exists(ID id);

  /// Get count of all items
  Future<int> count();

  /// Clear all items (use with caution)
  Future<void> clear();
}

/// Extended repository interface with search and filtering
abstract class ExtendedRepository<T, ID> extends BaseRepository<T, ID> {
  /// Search items by query
  Future<List<T>> search(String query);

  /// Get items with pagination
  Future<List<T>> getPaginated({
    int offset = 0,
    int limit = 20,
    String? orderBy,
    bool ascending = true,
  });

  /// Get items by filter
  Future<List<T>> getByFilter(Map<String, dynamic> filters);

  /// Batch operations
  Future<List<T>> createBatch(List<T> items);
  Future<List<T>> updateBatch(List<T> items);
  Future<void> deleteBatch(List<ID> ids);
}

/// Repository interface for user-scoped data
abstract class UserScopedRepository<T, ID> extends ExtendedRepository<T, ID> {
  /// Get items for a specific user
  Future<List<T>> getByUserId(String userId);

  /// Get count of items for a user
  Future<int> countByUserId(String userId);

  /// Delete all items for a user
  Future<void> deleteByUserId(String userId);
}

/// Repository interface for workspace-scoped data
abstract class WorkspaceScopedRepository<T, ID>
    extends UserScopedRepository<T, ID> {
  /// Get items for a specific workspace
  Future<List<T>> getByWorkspaceId(String workspaceId);

  /// Get count of items for a workspace
  Future<int> countByWorkspaceId(String workspaceId);

  /// Delete all items for a workspace
  Future<void> deleteByWorkspaceId(String workspaceId);

  /// Get items for a user within a workspace
  Future<List<T>> getByUserAndWorkspace(String userId, String workspaceId);
}
