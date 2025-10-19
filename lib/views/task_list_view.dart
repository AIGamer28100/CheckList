import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/masonry_task_grid.dart';
import '../widgets/create_task_dialog.dart';
import 'settings_view.dart';

class TaskListView extends ConsumerStatefulWidget {
  const TaskListView({super.key});

  @override
  ConsumerState<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends ConsumerState<TaskListView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskViewModelProvider).loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = ref.watch(taskViewModelProvider);
    final tasks = taskViewModel.tasks;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: _isSearchVisible ? 140 : 100,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.05),
                        colorScheme.secondary.withValues(alpha: 0.03),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.primary,
                                      colorScheme.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CheckList',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                          ),
                                    ),
                                    Text(
                                      '${tasks.length} tasks',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildActionButtons(context, colorScheme),
                            ],
                          ),
                          if (_isSearchVisible) ...[
                            const SizedBox(height: 16),
                            _buildSearchBar(context, colorScheme),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            await ref.read(taskViewModelProvider).loadTasks();
          },
          child: CustomScrollView(
            slivers: [
              if (taskViewModel.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (tasks.isEmpty)
                SliverFillRemaining(child: _buildEmptyState(context))
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: MasonryTaskGrid(
                      tasks: tasks,
                      onToggleComplete: (task) => ref
                          .read(taskViewModelProvider)
                          .markTaskCompleted(task.id),
                      onEdit: (task) => _showEditTaskDialog(context, task),
                      onDelete: (task) =>
                          _showDeleteConfirmation(context, task),
                    ),
                  ),
                ),
              // Add some bottom padding for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          context,
          icon: _isSearchVisible ? Icons.close : Icons.search,
          onPressed: () {
            setState(() {
              _isSearchVisible = !_isSearchVisible;
              if (!_isSearchVisible) {
                _searchController.clear();
                ref.read(taskViewModelProvider).searchTasks('');
              }
            });
          },
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context,
          icon: Icons.filter_list,
          onPressed: () => _showFilterDialog(context),
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context,
          icon: Icons.settings,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsView()),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(foregroundColor: colorScheme.onSurface),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            size: 20,
          ),
        ),
        onChanged: (value) {
          ref.read(taskViewModelProvider).searchTasks(value);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.1),
                    colorScheme.secondary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.checklist_rtl,
                size: 60,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start organizing your work by creating your first task',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showCreateTaskDialog(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Create First Task'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showCreateTaskDialog(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreateTaskDialog(
        onTaskCreated: (taskData) {
          ref
              .read(taskViewModelProvider)
              .createTask(
                title: taskData['title'],
                description: taskData['description'],
                priority: taskData['priority'] ?? TaskPriority.medium,
                dueDate: taskData['dueDate'],
                reminderTime: taskData['reminderTime'],
                tags: taskData['tags'] ?? [],
                location: taskData['location'],
                estimatedMinutes: taskData['estimatedMinutes'],
                createdBy: 'current_user',
              );
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    // For now, just show create dialog - edit functionality needs more work
    _showCreateTaskDialog(context);
  }

  void _showDeleteConfirmation(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(taskViewModelProvider).deleteTask(task.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final taskViewModel = ref.read(taskViewModelProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status filter
            ListTile(
              title: const Text('Status'),
              subtitle: DropdownButton<TaskStatus?>(
                value: taskViewModel.statusFilter,
                isExpanded: true,
                hint: const Text('All statuses'),
                items: [
                  const DropdownMenuItem<TaskStatus?>(
                    value: null,
                    child: Text('All'),
                  ),
                  ...TaskStatus.values.map((status) {
                    return DropdownMenuItem<TaskStatus?>(
                      value: status,
                      child: Text(_getStatusText(status)),
                    );
                  }),
                ],
                onChanged: (status) {
                  taskViewModel.applyFilters(status: status);
                },
              ),
            ),
            // Priority filter
            ListTile(
              title: const Text('Priority'),
              subtitle: DropdownButton<TaskPriority?>(
                value: taskViewModel.priorityFilter,
                isExpanded: true,
                hint: const Text('All priorities'),
                items: [
                  const DropdownMenuItem<TaskPriority?>(
                    value: null,
                    child: Text('All'),
                  ),
                  ...TaskPriority.values.map((priority) {
                    return DropdownMenuItem<TaskPriority?>(
                      value: priority,
                      child: Text(_getPriorityText(priority)),
                    );
                  }),
                ],
                onChanged: (priority) {
                  taskViewModel.applyFilters(priority: priority);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(taskViewModelProvider).clearFilters();
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }
}
