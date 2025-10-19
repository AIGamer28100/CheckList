import 'package:flutter/material.dart';
import '../models/task.dart';

// Consistent spacing throughout the app
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

// Consistent border radius
class AppRadius {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
}

class MasonryTaskGrid extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task)? onToggleComplete;
  final Function(Task)? onEdit;
  final Function(Task)? onDelete;

  const MasonryTaskGrid({
    super.key,
    required this.tasks,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks available'));
    }

    final screenWidth = MediaQuery.of(context).size.width;

    // Determine number of columns based on screen width
    int columns = 1;
    if (screenWidth >= 1200) {
      columns = 4;
    } else if (screenWidth >= 900) {
      columns = 3;
    } else if (screenWidth >= 600) {
      columns = 2;
    }

    if (columns == 1) {
      // Single column layout for mobile
      return Column(
        children: List.generate(tasks.length, (index) {
          final task = tasks[index];
          return KeepStyleTaskCard(
            task: task,
            onToggleComplete: () => onToggleComplete?.call(task),
            onEdit: () => onEdit?.call(task),
            onDelete: () => onDelete?.call(task),
          );
        }),
      );
    }

    // Multi-column cascading layout for wider screens
    return _buildMasonryGrid(context, columns);
  }

  Widget _buildMasonryGrid(BuildContext context, int columns) {
    // Distribute tasks across columns
    List<List<Task>> columnTasks = List.generate(columns, (_) => []);

    for (int i = 0; i < tasks.length; i++) {
      columnTasks[i % columns].add(tasks[i]);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(columns, (colIndex) {
            return Expanded(
              child: Column(
                children: List.generate(columnTasks[colIndex].length, (rowIndex) {
                  final task = columnTasks[colIndex][rowIndex];
                  return KeepStyleTaskCard(
                    task: task,
                    onToggleComplete: () => onToggleComplete?.call(task),
                    onEdit: () => onEdit?.call(task),
                    onDelete: () => onDelete?.call(task),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class KeepStyleTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const KeepStyleTaskCard({
    super.key,
    required this.task,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priorityColor = _getPriorityColor(task.priority);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border(
                left: BorderSide(
                  color: priorityColor,
                  width: 4,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with priority badge and actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Priority and checkbox
                      Row(
                        children: [
                          _buildStatusCheckbox(),
                          const SizedBox(width: AppSpacing.md),
                          _buildPriorityBadge(context),
                        ],
                      ),
                      _buildActionMenu(context),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Title
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: task.status == TaskStatus.completed
                          ? colorScheme.onSurface.withValues(alpha: 0.5)
                          : colorScheme.onSurface,
                      decoration: task.status == TaskStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Description
                  if (task.description?.isNotEmpty == true) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      task.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Tags
                  if (task.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: task.tags.take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                          child: Text(
                            tag,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Footer with meta information
                  if (task.dueDate != null || task.estimatedMinutes != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _buildFooter(context),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCheckbox() {
    return GestureDetector(
      onTap: onToggleComplete,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: task.status == TaskStatus.completed
              ? _getPriorityColor(task.priority)
              : Colors.transparent,
          border: Border.all(
            color: _getPriorityColor(task.priority),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        child: task.status == TaskStatus.completed
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getPriorityColor(task.priority).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Text(
        _getPriorityText(task.priority),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: _getPriorityColor(task.priority),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: AppSpacing.md),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 16),
              SizedBox(width: AppSpacing.md),
              Text('Delete'),
            ],
          ),
        ),
      ],
      child: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        size: 20,
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = <Widget>[];

    if (task.dueDate != null) {
      items.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              _formatDate(task.dueDate!),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    if (task.estimatedMinutes != null) {
      items.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '${task.estimatedMinutes}m',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(spacing: AppSpacing.lg, runSpacing: AppSpacing.sm, children: items);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.urgent:
        return Colors.red;
    }
  }
}
