import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Material3DemoView extends ConsumerWidget {
  const Material3DemoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Material 3 Components',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Showcasing the new Material You design system',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Button Section
            _buildSection(context, 'Buttons', [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(onPressed: () {}, child: const Text('Filled')),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Filled Tonal'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined'),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Text')),
                ],
              ),
            ]),

            // Cards Section
            _buildSection(context, 'Cards', [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Elevated Card',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This is an example of a Material 3 card with improved elevation and styling.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Card.filled(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filled Card',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This card uses a filled background color for better visual hierarchy.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outlined Card',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This card has an outlined border instead of elevation.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ]),

            // Input Section
            _buildSection(context, 'Text Fields', [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Filled Text Field',
                  hintText: 'Enter some text',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Outlined Text Field',
                  hintText: 'Enter some text',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
            ]),

            // Chips Section
            _buildSection(context, 'Chips', [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: const Text('Input Chip'), onDeleted: () {}),
                  FilterChip(
                    label: const Text('Filter Chip'),
                    selected: true,
                    onSelected: (selected) {},
                  ),
                  ActionChip(
                    label: const Text('Action Chip'),
                    onPressed: () {},
                    avatar: const Icon(Icons.add, size: 18),
                  ),
                  ChoiceChip(
                    label: const Text('Choice Chip'),
                    selected: false,
                    onSelected: (selected) {},
                  ),
                ],
              ),
            ]),

            // Navigation Section
            _buildSection(context, 'Navigation', [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.home, 'Home', true),
                    _buildNavItem(Icons.search, 'Search', false),
                    _buildNavItem(Icons.favorite, 'Favorites', false),
                    _buildNavItem(Icons.person, 'Profile', false),
                  ],
                ),
              ),
            ]),

            // Color Palette Section
            _buildSection(context, 'Color Palette', [
              _buildColorPalette(context),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Material 3 FAB pressed!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create'),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...children,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool selected) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? colorScheme.secondaryContainer : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected
                    ? colorScheme.onSecondaryContainer
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorPalette(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final colors = [
      ('Primary', colorScheme.primary, colorScheme.onPrimary),
      ('Secondary', colorScheme.secondary, colorScheme.onSecondary),
      ('Tertiary', colorScheme.tertiary, colorScheme.onTertiary),
      ('Error', colorScheme.error, colorScheme.onError),
      ('Surface', colorScheme.surface, colorScheme.onSurface),
      (
        'Surface Variant',
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurface,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final (name, color, onColor) = colors[index];
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                color: onColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
