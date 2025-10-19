import 'dart:io';
import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:local_notifier/local_notifier.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../utils/database_helper.dart';

/// Service for managing desktop-specific features
class DesktopService {
  static final DesktopService _instance = DesktopService._internal();
  factory DesktopService() => _instance;
  DesktopService._internal();

  final SystemTray _systemTray = SystemTray();
  final Menu _menu = Menu();
  bool _isInitialized = false;

  /// Check if running on desktop platform
  static bool get isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  /// Initialize desktop features
  Future<void> initialize() async {
    if (!isDesktop || _isInitialized) return;

    try {
      // Initialize window manager
      await _initializeWindowManager();

      // Initialize system tray
      await _initializeSystemTray();

      // Initialize notifications
      await _initializeNotifications();

      // Initialize launch at startup
      await _initializeLaunchAtStartup();

      _isInitialized = true;
      debugPrint('Desktop service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing desktop service: $e');
    }
  }

  /// Initialize window manager
  Future<void> _initializeWindowManager() async {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'CheckList',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  /// Initialize system tray
  Future<void> _initializeSystemTray() async {
    try {
      // Get icon path based on platform
      String iconPath = await _getIconPath();

      await _systemTray.initSystemTray(
        title: 'CheckList',
        iconPath: iconPath,
        toolTip: 'CheckList - Task Manager',
      );

      // Build and set the menu
      await _buildSystemTrayMenu();

      debugPrint('System tray initialized with icon: $iconPath');
    } catch (e) {
      debugPrint('Error initializing system tray: $e');
    }
  }

  /// Get platform-specific icon path
  Future<String> _getIconPath() async {
    if (Platform.isWindows) {
      return 'assets/icon/icon.ico';
    } else if (Platform.isMacOS) {
      return 'assets/icon/icon.png';
    } else {
      // Linux
      return 'assets/icon/icon.png';
    }
  }

  /// Build system tray menu
  Future<void> _buildSystemTrayMenu() async {
    await _menu.buildFrom([
      MenuItemLabel(label: 'CheckList', enabled: false),
      MenuSeparator(),
      MenuItemLabel(label: 'Show Window', onClicked: (_) => _showWindow()),
      MenuItemLabel(
        label: 'Quick Add Task',
        onClicked: (_) => _showQuickAddTask(),
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: 'Task Statistics',
        onClicked: (_) => _showTaskStatistics(),
      ),
      MenuSeparator(),
      MenuItemLabel(label: 'Settings', onClicked: (_) => _showSettings()),
      MenuSeparator(),
      MenuItemLabel(label: 'Exit', onClicked: (_) => _exitApp()),
    ]);

    await _systemTray.setContextMenu(_menu);
  }

  /// Update system tray with task count
  Future<void> updateTrayWithTaskCount() async {
    if (!isDesktop || !_isInitialized) return;

    try {
      final repository = TaskRepository(DatabaseHelper());
      final tasks = await repository.getAll();

      final pendingTasks = tasks
          .where(
            (t) =>
                t.status != TaskStatus.completed &&
                t.status != TaskStatus.cancelled,
          )
          .length;

      final todayTasks = tasks.where((t) => t.isDueToday).length;

      // Update tray tooltip
      await _systemTray.setToolTip(
        'CheckList - $pendingTasks pending tasks, $todayTasks due today',
      );

      // Rebuild menu with updated stats
      await _buildSystemTrayMenu();
    } catch (e) {
      debugPrint('Error updating tray: $e');
    }
  }

  /// Show main window
  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  /// Show quick add task (would open a dialog)
  void _showQuickAddTask() {
    _showWindow();
    // TODO: Emit event to show quick add dialog
    debugPrint('Quick add task clicked');
  }

  /// Show task statistics
  void _showTaskStatistics() {
    _showWindow();
    // TODO: Navigate to statistics view
    debugPrint('Task statistics clicked');
  }

  /// Show settings
  void _showSettings() {
    _showWindow();
    // TODO: Navigate to settings
    debugPrint('Settings clicked');
  }

  /// Exit application
  Future<void> _exitApp() async {
    await windowManager.destroy();
    exit(0);
  }

  /// Initialize local notifications
  Future<void> _initializeNotifications() async {
    await localNotifier.setup(
      appName: 'CheckList',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  /// Show desktop notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? subtitle,
  }) async {
    if (!isDesktop) return;

    try {
      final notification = LocalNotification(
        title: title,
        body: body,
        subtitle: subtitle,
      );

      await notification.show();
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Show task reminder notification
  Future<void> showTaskReminder(Task task) async {
    String body = 'Task: ${task.title}';
    if (task.dueDate != null) {
      body += '\nDue: ${task.dueDate}';
    }

    await showNotification(
      title: 'Task Reminder',
      body: body,
      subtitle: 'Priority: ${task.priority.name}',
    );
  }

  /// Initialize launch at startup
  Future<void> _initializeLaunchAtStartup() async {
    try {
      launchAtStartup.setup(
        appName: 'CheckList',
        appPath: Platform.resolvedExecutable,
        packageName: 'com.example.todo_app',
      );

      // Check if enabled (default to false)
      final isEnabled = await launchAtStartup.isEnabled();
      debugPrint('Launch at startup enabled: $isEnabled');
    } catch (e) {
      debugPrint('Error initializing launch at startup: $e');
    }
  }

  /// Enable/disable launch at startup
  Future<void> setLaunchAtStartup(bool enabled) async {
    if (!isDesktop) return;

    try {
      if (enabled) {
        await launchAtStartup.enable();
      } else {
        await launchAtStartup.disable();
      }
      debugPrint('Launch at startup set to: $enabled');
    } catch (e) {
      debugPrint('Error setting launch at startup: $e');
    }
  }

  /// Check if launch at startup is enabled
  Future<bool> isLaunchAtStartupEnabled() async {
    if (!isDesktop) return false;

    try {
      return await launchAtStartup.isEnabled();
    } catch (e) {
      debugPrint('Error checking launch at startup: $e');
      return false;
    }
  }

  /// Handle window close event
  Future<void> handleWindowClose() async {
    // Hide to tray instead of closing
    await windowManager.hide();
  }

  /// Minimize to tray
  Future<void> minimizeToTray() async {
    if (!isDesktop) return;
    await windowManager.hide();

    await showNotification(
      title: 'CheckList',
      body: 'App minimized to system tray',
    );
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _systemTray.destroy();
      _isInitialized = false;
    } catch (e) {
      debugPrint('Error disposing desktop service: $e');
    }
  }
}
