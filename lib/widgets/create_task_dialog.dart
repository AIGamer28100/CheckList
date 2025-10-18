import 'package:flutter/material.dart';
import '../models/task.dart';

class CreateTaskDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onTaskCreated;

  const CreateTaskDialog({super.key, required this.onTaskCreated});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _dueDate;
  DateTime? _reminderTime;
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Task'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'Enter task title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Description field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 16),

                // Priority selection
                Text('Priority', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: TaskPriority.values.map((priority) {
                    return FilterChip(
                      label: Text(_getPriorityText(priority)),
                      selected: _selectedPriority == priority,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedPriority = priority;
                          });
                        }
                      },
                      selectedColor: _getPriorityColor(
                        priority,
                      ).withOpacity(0.3),
                      checkmarkColor: _getPriorityColor(priority),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Due date selection
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dueDate == null
                            ? 'No due date'
                            : 'Due: ${_formatDate(_dueDate!)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _selectDueDate,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Set Due Date'),
                    ),
                    if (_dueDate != null)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _dueDate = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear due date',
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Reminder time selection
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _reminderTime == null
                            ? 'No reminder'
                            : 'Reminder: ${_formatDateTime(_reminderTime!)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _selectReminderTime,
                      icon: const Icon(Icons.notifications),
                      label: const Text('Set Reminder'),
                    ),
                    if (_reminderTime != null)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _reminderTime = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear reminder',
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tags section
                Text('Tags', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tagController,
                        decoration: const InputDecoration(
                          hintText: 'Add a tag',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onFieldSubmitted: _addTag,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _addTag(_tagController.text),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                if (_tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: _tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            onDeleted: () => _removeTag(tag),
                            deleteIcon: const Icon(Icons.close, size: 16),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createTask,
          child: const Text('Create Task'),
        ),
      ],
    );
  }

  void _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  void _selectReminderTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderTime?.toLocal() ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderTime ?? DateTime.now()),
      );

      if (time != null) {
        setState(() {
          _reminderTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !_tags.contains(trimmedTag)) {
      setState(() {
        _tags.add(trimmedTag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _createTask() {
    if (_formKey.currentState!.validate()) {
      final taskData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'priority': _selectedPriority,
        'dueDate': _dueDate,
        'reminderTime': _reminderTime,
        'tags': _tags,
      };

      widget.onTaskCreated(taskData);
      Navigator.pop(context);
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

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.purple;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
