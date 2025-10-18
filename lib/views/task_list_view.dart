import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/task_card.dart';
import '../widgets/create_task_dialog.dart';
import 'settings_view.dart';

class TaskListView extends ConsumerStatefulWidget {
  const TaskListView({super.key});

  @override
  ConsumerState<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends ConsumerState<TaskListView> {
  @override
  void initState() {
    super.initState();
    // Load tasks when the view is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskViewModelProvider).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = ref.watch(taskViewModelProvider);
    final tasks = taskViewModel.tasks;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('CheckList'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () => _showSearchDialog(context),
                tooltip: 'Search tasks',
              ),
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsView()),
                ),
                tooltip: 'Settings',
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Content
          SliverToBoxAdapter(child: _buildBody(context, taskViewModel, tasks)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTaskDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
        tooltip: 'Create new task',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody(
    BuildContext context,
    TaskViewModel viewModel,
    List<Task> tasks,
  ) {
    if (viewModel.isLoading) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading your tasks...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.hasError) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.errorMessage ?? 'Unknown error occurred',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => viewModel.clearError(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.task_alt_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No tasks yet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Start organizing your life by creating\nyour first task',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => _showCreateTaskDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create First Task'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Welcome Header & Quick Stats
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildWelcomeHeader(context, viewModel),
        ),

        // Quick Actions
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildQuickActions(context),
        ),

        const SizedBox(height: 16),

        // Task List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => viewModel.refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: TaskCard(
                    task: task,
                    onTap: () => _selectTask(task),
                    onToggleComplete: () => _toggleTaskComplete(task),
                    onEdit: () => _editTask(task),
                    onDelete: () => _deleteTask(task),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, TaskViewModel viewModel) {
    final completedCount = viewModel.completedTasks;
    final totalCount = viewModel.totalTasks;
    final pendingCount = viewModel.pendingTasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalCount == 0
                        ? 'Ready to start your day?'
                        : pendingCount == 0
                        ? 'All tasks completed! 🎉'
                        : '$pendingCount task${pendingCount == 1 ? '' : 's'} pending',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (totalCount > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: completedCount == totalCount
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '$completedCount/$totalCount',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: completedCount == totalCount
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'completed',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: completedCount == totalCount
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        if (totalCount > 0) ...[
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: totalCount > 0 ? completedCount / totalCount : 0,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _showCreateTaskDialog(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.add_task_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quick Task',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () => _showSearchDialog(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 4),
                  Text('Search', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () => _showFilterOptions(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 4),
                  Text('Filter', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () => _showSortOptions(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.sort_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 4),
                  Text('Sort', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning!';
    } else if (hour < 17) {
      return 'Good afternoon!';
    } else {
      return 'Good evening!';
    }
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Tasks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.all_inclusive_rounded),
              title: const Text('All Tasks'),
              onTap: () {
                ref.read(taskViewModelProvider).clearFilters();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.radio_button_unchecked_rounded),
              title: const Text('Pending Tasks'),
              onTap: () {
                ref
                    .read(taskViewModelProvider)
                    .applyFilters(status: TaskStatus.todo);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_rounded),
              title: const Text('Completed Tasks'),
              onTap: () {
                ref
                    .read(taskViewModelProvider)
                    .applyFilters(status: TaskStatus.completed);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort Tasks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time_rounded),
              title: const Text('By Date Created'),
              onTap: () {
                ref.read(taskViewModelProvider).sortTasks('createdAt');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.title_rounded),
              title: const Text('By Title'),
              onTap: () {
                ref.read(taskViewModelProvider).sortTasks('title');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.priority_high_rounded),
              title: const Text('By Priority'),
              onTap: () {
                ref.read(taskViewModelProvider).sortTasks('priority');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          CreateTaskDialog(onTaskCreated: (task) => _createTask(task)),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Tasks'),
        content: TextField(
          onChanged: (query) =>
              ref.read(taskViewModelProvider).searchTasks(query),
          decoration: const InputDecoration(
            hintText: 'Enter search query...',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(taskViewModelProvider).searchTasks('');
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _selectTask(Task task) {
    ref.read(taskViewModelProvider).selectTask(task);
    // You can navigate to a detailed view here
  }

  void _toggleTaskComplete(Task task) {
    if (task.status == TaskStatus.completed) {
      // Mark as todo
      final updatedTask = task.copyWith(
        status: TaskStatus.todo,
        completionPercentage: 0,
        completedAt: null,
        updatedAt: DateTime.now(),
      );
      ref.read(taskViewModelProvider).updateTask(updatedTask);
    } else {
      // Mark as completed
      ref.read(taskViewModelProvider).markTaskCompleted(task.id);
    }
  }

  void _editTask(Task task) {
    // TODO: Implement edit task dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit task feature coming soon!')),
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskViewModelProvider).deleteTask(task.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _createTask(Map<String, dynamic> taskData) async {
    await ref
        .read(taskViewModelProvider)
        .createTask(
          title: taskData['title'] ?? '',
          description: taskData['description'],
          priority: taskData['priority'] ?? TaskPriority.medium,
          dueDate: taskData['dueDate'],
          reminderTime: taskData['reminderTime'],
          tags: taskData['tags'] ?? [],
          location: taskData['location'],
          estimatedMinutes: taskData['estimatedMinutes'],
          createdBy: 'default_user', // TODO: Get from auth service
        );
  }
}
