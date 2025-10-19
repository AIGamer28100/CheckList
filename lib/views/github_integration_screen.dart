import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/github_repository.dart';
import '../services/github_service.dart';
import '../config/environment_config.dart';

/// Screen for GitHub integration settings and repository management
class GitHubIntegrationScreen extends ConsumerStatefulWidget {
  const GitHubIntegrationScreen({super.key});

  @override
  ConsumerState<GitHubIntegrationScreen> createState() =>
      _GitHubIntegrationScreenState();
}

class _GitHubIntegrationScreenState
    extends ConsumerState<GitHubIntegrationScreen> {
  final GitHubService _githubService = GitHubService();
  final TextEditingController _tokenController = TextEditingController();

  bool _isLoading = false;
  bool _isConnected = false;
  String? _username;
  List<GitHubRepository> _repositories = [];
  GitHubIntegrationSettings _settings = GitHubIntegrationSettings();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    // Load saved settings from SharedPreferences or secure storage
    // For now, we'll check if there's a token in environment
    final token = EnvironmentConfig.githubToken;
    if (token != null && token.isNotEmpty) {
      await _connectWithToken(token);
    }
  }

  Future<void> _connectWithToken(String token) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _githubService.initialize(token);
      final user = await _githubService.getCurrentUser();

      if (user != null) {
        final repos = await _githubService.getUserRepositories();

        setState(() {
          _isConnected = true;
          _username = user.login;
          _repositories = repos;
          _settings = _settings.copyWith(accessToken: token);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connected as @$_username'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _disconnect() async {
    setState(() {
      _isConnected = false;
      _username = null;
      _repositories = [];
      _settings = GitHubIntegrationSettings();
      _tokenController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Disconnected from GitHub')));
    }
  }

  void _toggleRepositorySelection(GitHubRepository repo) {
    setState(() {
      _repositories = _repositories.map((r) {
        if (r.id == repo.id) {
          return r.copyWith(isSelected: !r.isSelected);
        }
        return r;
      }).toList();

      final selectedRepos = _repositories
          .where((r) => r.isSelected)
          .map((r) => r.fullName)
          .toList();

      _settings = _settings.copyWith(selectedRepositories: selectedRepos);
    });
  }

  Future<void> _saveSettings() async {
    // Save settings to SharedPreferences or secure storage
    // This would persist the token and selected repositories

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Integration'),
        actions: [
          if (_isConnected)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveSettings,
              tooltip: 'Save Settings',
            ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isConnected) {
      return _buildConnectionForm(theme);
    }

    return _buildConnectedView(theme);
  }

  Widget _buildConnectionForm(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.code, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Connect to GitHub',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Import tasks from GitHub Issues and Pull Requests',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ),
            ),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              labelText: 'GitHub Personal Access Token',
              hintText: 'ghp_xxxxxxxxxxxxxxxxxxxx',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.vpn_key),
              helperText: 'Generate a token at github.com/settings/tokens',
              helperMaxLines: 2,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              if (_tokenController.text.trim().isNotEmpty) {
                _connectWithToken(_tokenController.text.trim());
              }
            },
            icon: const Icon(Icons.link),
            label: const Text('Connect'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Open GitHub token generation page
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Generate Token'),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedView(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async {
        if (_settings.accessToken != null) {
          await _connectWithToken(_settings.accessToken!);
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAccountCard(theme),
          const SizedBox(height: 16),
          _buildSyncSettings(theme),
          const SizedBox(height: 16),
          _buildRepositoriesList(theme),
        ],
      ),
    );
  }

  Widget _buildAccountCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    _username?.substring(0, 1).toUpperCase() ?? 'U',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('@$_username', style: theme.textTheme.titleMedium),
                      Text(
                        'Connected',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: _disconnect,
                  icon: const Icon(Icons.link_off),
                  label: const Text('Disconnect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncSettings(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sync Settings', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Sync Issues'),
              subtitle: const Text('Import GitHub Issues as tasks'),
              value: _settings.syncIssues,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(syncIssues: value);
                });
              },
            ),
            SwitchListTile(
              title: const Text('Sync Pull Requests'),
              subtitle: const Text('Import Pull Requests as tasks'),
              value: _settings.syncPullRequests,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(syncPullRequests: value);
                });
              },
            ),
            SwitchListTile(
              title: const Text('Bidirectional Sync'),
              subtitle: const Text('Push task changes back to GitHub'),
              value: _settings.bidirectionalSync,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(bidirectionalSync: value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepositoriesList(ThemeData theme) {
    final selectedCount = _repositories.where((r) => r.isSelected).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Repositories', style: theme.textTheme.titleMedium),
                Chip(
                  label: Text('$selectedCount selected'),
                  backgroundColor: theme.colorScheme.primaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select repositories to sync',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (_repositories.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No repositories found'),
                ),
              )
            else
              ...List.generate(_repositories.length, (index) {
                final repo = _repositories[index];
                return _buildRepositoryTile(repo, theme);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildRepositoryTile(GitHubRepository repo, ThemeData theme) {
    return CheckboxListTile(
      value: repo.isSelected,
      onChanged: (_) => _toggleRepositorySelection(repo),
      title: Text(
        repo.fullName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (repo.description != null && repo.description!.isNotEmpty)
            Text(
              repo.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (repo.isPrivate)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Private',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              if (repo.isPrivate) const SizedBox(width: 8),
              Icon(
                Icons.bug_report,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '${repo.openIssuesCount ?? 0}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 12),
              Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${repo.stargazersCount ?? 0}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
      isThreeLine: repo.description != null && repo.description!.isNotEmpty,
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _githubService.dispose();
    super.dispose();
  }
}
