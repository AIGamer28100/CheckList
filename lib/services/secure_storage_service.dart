import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for managing secure storage of sensitive data
class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Keys for stored values
  static const String _githubTokenKey = 'github_access_token';
  static const String _githubUsernameKey = 'github_username';
  static const String _githubSelectedReposKey = 'github_selected_repos';

  /// Save GitHub access token securely
  Future<void> saveGitHubToken(String token) async {
    await _storage.write(key: _githubTokenKey, value: token);
  }

  /// Retrieve GitHub access token
  Future<String?> getGitHubToken() async {
    return await _storage.read(key: _githubTokenKey);
  }

  /// Delete GitHub access token
  Future<void> deleteGitHubToken() async {
    await _storage.delete(key: _githubTokenKey);
  }

  /// Save GitHub username
  Future<void> saveGitHubUsername(String username) async {
    await _storage.write(key: _githubUsernameKey, value: username);
  }

  /// Retrieve GitHub username
  Future<String?> getGitHubUsername() async {
    return await _storage.read(key: _githubUsernameKey);
  }

  /// Delete GitHub username
  Future<void> deleteGitHubUsername() async {
    await _storage.delete(key: _githubUsernameKey);
  }

  /// Save selected GitHub repositories (comma-separated)
  Future<void> saveGitHubSelectedRepos(List<String> repos) async {
    await _storage.write(key: _githubSelectedReposKey, value: repos.join(','));
  }

  /// Retrieve selected GitHub repositories
  Future<List<String>> getGitHubSelectedRepos() async {
    final value = await _storage.read(key: _githubSelectedReposKey);
    if (value == null || value.isEmpty) return [];
    return value.split(',');
  }

  /// Delete selected GitHub repositories
  Future<void> deleteGitHubSelectedRepos() async {
    await _storage.delete(key: _githubSelectedReposKey);
  }

  /// Clear all GitHub-related data
  Future<void> clearGitHubData() async {
    await deleteGitHubToken();
    await deleteGitHubUsername();
    await deleteGitHubSelectedRepos();
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
