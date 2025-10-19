import 'dart:io';
import 'package:flutter/material.dart';
import '../services/desktop_service.dart';

/// Screen for managing desktop-specific settings
class DesktopSettingsScreen extends StatefulWidget {
  const DesktopSettingsScreen({super.key});

  @override
  State<DesktopSettingsScreen> createState() => _DesktopSettingsScreenState();
}

class _DesktopSettingsScreenState extends State<DesktopSettingsScreen> {
  final _desktopService = DesktopService();
  bool _isLoading = true;
  bool _launchAtStartup = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final enabled = await _desktopService.isLaunchAtStartupEnabled();
      setState(() {
        _launchAtStartup = enabled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error loading settings: $e';
      });
    }
  }

  Future<void> _toggleLaunchAtStartup(bool value) async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Updating settings...';
    });

    try {
      await _desktopService.setLaunchAtStartup(value);
      setState(() {
        _launchAtStartup = value;
        _isLoading = false;
        _statusMessage = value
            ? 'Launch at startup enabled'
            : 'Launch at startup disabled';
      });

      // Clear message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _statusMessage = '');
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: $e';
      });
    }
  }

  Future<void> _testNotification() async {
    await _desktopService.showNotification(
      title: 'Test Notification',
      body: 'This is a test notification from CheckList',
      subtitle: 'Desktop Integration',
    );

    setState(() {
      _statusMessage = 'Test notification sent!';
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _statusMessage = '');
      }
    });
  }

  Future<void> _minimizeToTray() async {
    await _desktopService.minimizeToTray();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Desktop Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Status message
                if (_statusMessage.isNotEmpty) ...[
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 12),
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
                  ),
                  const SizedBox(height: 16),
                ],

                // Platform info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getPlatformIcon(),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Platform Information',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Operating System', _getPlatformName()),
                        _buildInfoRow(
                          'Desktop Mode',
                          DesktopService.isDesktop ? 'Enabled' : 'Disabled',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Startup Settings
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.power_settings_new,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Startup Settings',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      SwitchListTile(
                        title: const Text('Launch at Startup'),
                        subtitle: const Text(
                          'Automatically start CheckList when you log in',
                        ),
                        value: _launchAtStartup,
                        onChanged: _toggleLaunchAtStartup,
                        secondary: const Icon(Icons.rocket_launch),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // System Tray Settings
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.widgets,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'System Tray',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.minimize),
                        title: const Text('Minimize to Tray'),
                        subtitle: const Text(
                          'Hide the app window and keep it running in the background',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _minimizeToTray,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.update),
                        title: const Text('Update Tray Statistics'),
                        subtitle: const Text(
                          'Refresh task counts in the system tray',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await _desktopService.updateTrayWithTaskCount();
                          setState(() {
                            _statusMessage = 'Tray statistics updated!';
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Notifications
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Notifications',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.notification_add),
                        title: const Text('Test Notification'),
                        subtitle: const Text(
                          'Send a test desktop notification',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _testNotification,
                      ),
                    ],
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
                        Text(
                          'Desktop Features',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildFeature(
                          Icons.dashboard,
                          'System Tray Integration',
                          'Quick access to tasks from system tray',
                        ),
                        _buildFeature(
                          Icons.notifications_active,
                          'Desktop Notifications',
                          'Get notified about tasks and reminders',
                        ),
                        _buildFeature(
                          Icons.window,
                          'Window Management',
                          'Minimize to tray, always on top, and more',
                        ),
                        _buildFeature(
                          Icons.keyboard_command_key,
                          'Keyboard Shortcuts',
                          'Quick actions with keyboard shortcuts',
                        ),
                      ],
                    ),
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
                            const SizedBox(width: 12),
                            Text(
                              'System Tray Access',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (Platform.isWindows) ...[
                          const Text(
                            'Windows: Look for the CheckList icon in the system tray (bottom-right corner of your screen). Right-click for quick actions.',
                          ),
                        ] else if (Platform.isMacOS) ...[
                          const Text(
                            'macOS: Find the CheckList icon in the menu bar (top-right of your screen). Click for quick actions.',
                          ),
                        ] else if (Platform.isLinux) ...[
                          const Text(
                            'Linux: Look for the CheckList icon in your system tray (location varies by desktop environment). Click or right-click for quick actions.',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  IconData _getPlatformIcon() {
    if (Platform.isWindows) return Icons.desktop_windows;
    if (Platform.isMacOS) return Icons.desktop_mac;
    if (Platform.isLinux) return Icons.computer;
    return Icons.devices;
  }

  String _getPlatformName() {
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
