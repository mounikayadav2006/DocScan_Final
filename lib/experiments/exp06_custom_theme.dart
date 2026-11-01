import 'package:flutter/material.dart';

import '../widgets/custom_widgets.dart';

/// EXPERIMENT 6a - Custom reusable widget (CustomCardTile, see
/// lib/widgets/custom_widgets.dart) used several times.
class Exp6aCustomWidgetScreen extends StatelessWidget {
  const Exp6aCustomWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Reusable Widgets')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          CustomCardTile(
              title: 'Profile',
              subtitle: 'Manage user settings',
              icon: Icons.person),
          CustomCardTile(
              title: 'Notifications',
              subtitle: 'View recent alerts',
              icon: Icons.notifications),
          CustomCardTile(
              title: 'Scanned Documents',
              subtitle: 'Browse everything you scanned',
              icon: Icons.document_scanner),
        ],
      ),
    );
  }
}

/// EXPERIMENT 6b - ThemeData + inline style override.
class Exp6bThemeScreen extends StatefulWidget {
  const Exp6bThemeScreen({super.key});

  @override
  State<Exp6bThemeScreen> createState() => _Exp6bThemeScreenState();
}

class _Exp6bThemeScreenState extends State<Exp6bThemeScreen> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: _dark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: _dark ? null : Colors.grey.shade100,
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: _dark ? Colors.tealAccent : Colors.teal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Theme(
      data: theme,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('App Themes')),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Styled with ThemeData',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 12),
                const Text(
                  'Inline style (overrides the theme)',
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontStyle: FontStyle.italic,
                      fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () {}, child: const Text('Themed button')),
                SwitchListTile(
                  title: const Text('Dark theme'),
                  value: _dark,
                  onChanged: (v) => setState(() => _dark = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
