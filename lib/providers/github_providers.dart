import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/github_service.dart';
import '../services/github_sync_manager.dart';
import '../repositories/task_repository.dart';
import '../utils/database_helper.dart';

/// Provider for GitHub service
final githubServiceProvider = Provider<GitHubService>((ref) {
  return GitHubService();
});

/// Provider for GitHub sync manager
final githubSyncManagerProvider = Provider<GitHubSyncManager>((ref) {
  final githubService = ref.watch(githubServiceProvider);
  final taskRepository = TaskRepository(DatabaseHelper());
  
  return GitHubSyncManager(
    githubService: githubService,
    taskRepository: taskRepository,
  );
});

/// Provider for sync status stream
final syncStatusStreamProvider = StreamProvider<SyncStatus>((ref) {
  final syncManager = ref.watch(githubSyncManagerProvider);
  return syncManager.syncStatusStream;
});

/// Provider for last sync time
final lastSyncTimeProvider = Provider<DateTime?>((ref) {
  final syncManager = ref.watch(githubSyncManagerProvider);
  return syncManager.lastSyncTime;
});
