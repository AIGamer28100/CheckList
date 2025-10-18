import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

/// Home Screen for authenticated users
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final User? user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckList'),
        actions: [
          // User Profile
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  _showProfileDialog();
                  break;
                case 'sign_out':
                  await _signOut();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'sign_out',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? Text(
                        user?.displayName?.isNotEmpty == true
                            ? user!.displayName![0].toUpperCase()
                            : user?.email?.isNotEmpty == true
                            ? user!.email![0].toUpperCase()
                            : '?',
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: user != null
          ? TodoListView(userId: user.uid, firestoreService: _firestoreService)
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
      }
    }
  }

  void _showProfileDialog() {
    final User? user = _authService.currentUser;
    if (user == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.photoURL != null)
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
              ),
            const SizedBox(height: 16),
            _buildProfileRow('Name', user.displayName ?? 'Not set'),
            _buildProfileRow('Email', user.email ?? 'Not set'),
            _buildProfileRow('Phone', user.phoneNumber ?? 'Not set'),
            _buildProfileRow(
              'Email Verified',
              user.emailVerified ? 'Yes' : 'No',
            ),
            const SizedBox(height: 16),
            const Text(
              'Linked Accounts:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...user.providerData.map(
              (info) => Chip(
                label: Text(info.providerId),
                avatar: Icon(_getProviderIcon(info.providerId)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  IconData _getProviderIcon(String providerId) {
    switch (providerId) {
      case 'google.com':
        return Icons.login;
      case 'github.com':
        return Icons.code;
      case 'phone':
        return Icons.phone;
      case 'password':
        return Icons.email;
      default:
        return Icons.account_circle;
    }
  }

  void _showAddTodoDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  _authService.userId != null) {
                try {
                  await _firestoreService.addTodo(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    userId: _authService.userId!,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding todo: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// Todo List View Widget
class TodoListView extends StatelessWidget {
  final String userId;
  final FirestoreService firestoreService;

  const TodoListView({
    super.key,
    required this.userId,
    required this.firestoreService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: firestoreService.getTodosStream(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final todos = snapshot.data ?? [];

        if (todos.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.checklist_rtl, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No todos yet!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first todo',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Checkbox(
                  value: todo.completed,
                  onChanged: (value) async {
                    try {
                      await firestoreService.toggleTodoCompletion(
                        todo.id,
                        value ?? false,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating todo: $e')),
                        );
                      }
                    }
                  },
                ),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.completed
                        ? TextDecoration.lineThrough
                        : null,
                    color: todo.completed ? Colors.grey : null,
                  ),
                ),
                subtitle: todo.description.isNotEmpty
                    ? Text(
                        todo.description,
                        style: TextStyle(
                          decoration: todo.completed
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.completed ? Colors.grey : null,
                        ),
                      )
                    : null,
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'edit':
                        _showEditTodoDialog(context, todo);
                        break;
                      case 'delete':
                        _deleteTodo(context, todo);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditTodoDialog(BuildContext context, Todo todo) {
    final TextEditingController titleController = TextEditingController(
      text: todo.title,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: todo.description,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                try {
                  final updatedTodo = todo.copyWith(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                  );
                  await firestoreService.updateTodo(updatedTodo);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating todo: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteTodo(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await firestoreService.deleteTodo(todo.id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting todo: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
