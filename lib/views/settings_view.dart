import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../themes/theme_provider.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final dynamicColorAvailability = ref.watch(
      dynamicColorAvailabilityProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // Theme Mode Selection
                  Text(
                    'Theme Mode',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: AppThemeMode.values
                        .map(
                          (mode) => ListTile(
                            title: Text(mode.displayName),
                            subtitle: _getThemeModeSubtitle(mode),
                            leading: Icon(mode.icon),
                            trailing: Radio<AppThemeMode>(
                              value: mode,
                              groupValue: themeState.themeMode,
                              onChanged: (value) {
                                if (value != null) {
                                  themeNotifier.setThemeMode(value);
                                }
                              },
                            ),
                            onTap: () => themeNotifier.setThemeMode(mode),
                          ),
                        )
                        .toList(),
                  ),

                  const Divider(),

                  // Dynamic Colors Toggle
                  dynamicColorAvailability.when(
                    data: (isAvailable) => SwitchListTile(
                      title: const Text('Dynamic Colors'),
                      subtitle: Text(
                        isAvailable
                            ? 'Use colors from your wallpaper'
                            : 'Not available on this device',
                      ),
                      value: themeState.useDynamicColors,
                      onChanged: isAvailable
                          ? (value) => themeNotifier.toggleDynamicColors()
                          : null,
                      secondary: const Icon(Icons.palette),
                    ),
                    loading: () => const ListTile(
                      title: Text('Dynamic Colors'),
                      subtitle: Text('Checking availability...'),
                      leading: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (error, _) => const SwitchListTile(
                      title: Text('Dynamic Colors'),
                      subtitle: Text('Failed to check availability'),
                      value: false,
                      onChanged: null,
                      secondary: Icon(Icons.palette),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Color Preview Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Color Preview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildColorPreview(context),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // About Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Material 3 Design'),
                    subtitle: const Text('Following Material You guidelines'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.color_lens),
                    title: const Text('Dynamic Color Support'),
                    subtitle: const Text('Adapts to your system colors'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _getThemeModeSubtitle(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return const Text('Always use light theme');
      case AppThemeMode.dark:
        return const Text('Always use dark theme');
      case AppThemeMode.system:
        return const Text('Follow system setting');
    }
  }

  Widget _buildColorPreview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Primary colors row
        Row(
          children: [
            Expanded(
              child: _ColorCard(
                color: colorScheme.primary,
                onColor: colorScheme.onPrimary,
                label: 'Primary',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ColorCard(
                color: colorScheme.secondary,
                onColor: colorScheme.onSecondary,
                label: 'Secondary',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ColorCard(
                color: colorScheme.tertiary,
                onColor: colorScheme.onTertiary,
                label: 'Tertiary',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Surface colors row
        Row(
          children: [
            Expanded(
              child: _ColorCard(
                color: colorScheme.surface,
                onColor: colorScheme.onSurface,
                label: 'Surface',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ColorCard(
                color: colorScheme.surfaceContainerHighest,
                onColor: colorScheme.onSurface,
                label: 'Container',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ColorCard(
                color: colorScheme.error,
                onColor: colorScheme.onError,
                label: 'Error',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ColorCard extends StatelessWidget {
  final Color color;
  final Color onColor;
  final String label;

  const _ColorCard({
    required this.color,
    required this.onColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: onColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
