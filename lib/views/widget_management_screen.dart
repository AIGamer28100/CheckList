import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../services/widget_service.dart';

/// Screen for managing home screen widgets
class WidgetManagementScreen extends StatefulWidget {
  const WidgetManagementScreen({super.key});

  @override
  State<WidgetManagementScreen> createState() => _WidgetManagementScreenState();
}

class _WidgetManagementScreenState extends State<WidgetManagementScreen> {
  final _widgetService = WidgetService();
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _widgetService.setupWidgetCallbacks();
  }

  Future<void> _updateWidgets() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Updating widgets...';
    });

    await _widgetService.updateWidgets();

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _statusMessage = 'Widgets updated successfully!';
    });

    // Clear message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _statusMessage = '');
      }
    });
  }

  Future<void> _openWidgetPicker() async {
    try {
      setState(() {
        _statusMessage = 'Opening widget picker...';
      });

      await HomeWidget.renderFlutterWidget(
        _buildWidgetPreview(),
        logicalSize: const Size(400, 200),
        key: 'widget_preview',
      );

      if (!mounted) return;
      setState(() {
        _statusMessage = 'Add widget from your home screen!';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  Widget _buildWidgetPreview() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CheckList',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your tasks at a glance',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Pending',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Today',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen Widgets')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.widgets_outlined,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Home Screen Widgets',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Quick access to your tasks from your home screen',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_statusMessage.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (_isLoading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _statusMessage,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Actions
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Update Widgets'),
                  subtitle: const Text('Refresh widget data manually'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _isLoading ? null : _updateWidgets,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.add_box_outlined),
                  title: const Text('Add Widget to Home Screen'),
                  subtitle: const Text(
                    'Long press home screen > Widgets > CheckList',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _openWidgetPicker,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Available Widgets
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Available Widgets',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildWidgetOption(
                  'Small Widget (2x2)',
                  'Quick task overview with stats',
                  Icons.grid_view,
                  Colors.blue,
                ),
                const Divider(height: 1),
                _buildWidgetOption(
                  'Medium Widget (4x2)',
                  'Task list with upcoming items',
                  Icons.view_agenda,
                  Colors.green,
                ),
                const Divider(height: 1),
                _buildWidgetOption(
                  'Large Widget (4x4)',
                  'Full task manager with progress',
                  Icons.dashboard,
                  Colors.orange,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Instructions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Platform.isIOS
                            ? 'How to Add Widgets (iOS)'
                            : 'How to Add Widgets (Android)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (Platform.isIOS) ...[
                    _buildInstructionStep(1, 'Long press on your home screen'),
                    _buildInstructionStep(
                      2,
                      'Tap the "+" button in the top-left corner',
                    ),
                    _buildInstructionStep(
                      3,
                      'Search for "CheckList" or scroll to find it',
                    ),
                    _buildInstructionStep(
                      4,
                      'Choose Small, Medium, or Large widget',
                    ),
                    _buildInstructionStep(
                      5,
                      'Tap "Add Widget" to add to home screen',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Note: Widgets update automatically every 30 minutes. You can also update them manually using the button above.',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ] else ...[
                    _buildInstructionStep(1, 'Long press on your home screen'),
                    _buildInstructionStep(2, 'Tap "Widgets" or "Add widget"'),
                    _buildInstructionStep(3, 'Find "CheckList" in the list'),
                    _buildInstructionStep(4, 'Choose your preferred size'),
                    _buildInstructionStep(
                      5,
                      'Drag the widget to your home screen',
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Features
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Widget Features',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFeature(Icons.check_circle, 'Real-time task updates'),
                  _buildFeature(Icons.touch_app, 'Tap to open tasks'),
                  _buildFeature(
                    Icons.notifications,
                    'Task completion tracking',
                  ),
                  _buildFeature(Icons.trending_up, 'Progress visualization'),
                  _buildFeature(Icons.today, 'Today\'s tasks highlight'),
                  _buildFeature(Icons.warning_amber, 'Overdue task alerts'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildInstructionStep(int step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
