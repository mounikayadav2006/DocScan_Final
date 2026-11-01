import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../experiments/exp10_testing_debugging.dart';
import '../theme.dart';
import '../widgets/custom_widgets.dart';

/// EXPERIMENT 5b (Provider) + 6b (dynamic themes) + 6a (custom widgets).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark mode'),
            subtitle: const Text('Switches the whole app instantly'),
            value: state.themeMode == ThemeMode.dark,
            onChanged: state.setDark,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text('Accent colour',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              children: AppTheme.seeds.entries.map((e) {
                final selected = state.seed == e.value;
                return GestureDetector(
                  onTap: () => state.setSeed(e.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: e.value,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: selected ? Colors.black87 : Colors.transparent,
                          width: 3),
                    ),
                    child: selected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          CustomCardTile(
            title: 'Debug console',
            subtitle: 'Experiment 10b - logging & DevTools',
            icon: Icons.bug_report,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const Exp10bDebugScreen())),
          ),
          CustomCardTile(
            title: 'Documents stored',
            subtitle: '${state.documents.length} documents in local SQLite DB',
            icon: Icons.storage,
          ),
          const CustomCardTile(
            title: 'About DocScan',
            subtitle: 'Flutter + ML Kit OCR + SQLite + PDF  |  v1.0.0',
            icon: Icons.info_outline,
          ),
        ],
      ),
    );
  }
}
