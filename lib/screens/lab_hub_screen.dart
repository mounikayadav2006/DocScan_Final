import 'package:flutter/material.dart';

import '../experiments/exp01_setup.dart';
import '../experiments/exp02_widgets.dart';
import '../experiments/exp03_responsive.dart';
import '../experiments/exp04_navigation.dart';
import '../experiments/exp05_state.dart';
import '../experiments/exp06_custom_theme.dart';
import '../experiments/exp07_forms.dart';
import '../experiments/exp08_animation.dart';
import '../experiments/exp09_api.dart';
import '../experiments/exp10_testing_debugging.dart';

class _Exp {
  final String id;
  final String title;
  final String aim;
  final IconData icon;
  final WidgetBuilder builder;
  const _Exp(this.id, this.title, this.aim, this.icon, this.builder);
}

class _Unit {
  final String name;
  final List<_Exp> items;
  const _Unit(this.name, this.items);
}

/// Lab hub: every experiment of the manual can be launched from here.
class LabHubScreen extends StatelessWidget {
  const LabHubScreen({super.key});

  static final List<_Unit> _units = [
    _Unit('Unit 1 - Setup & Dart', [
      _Exp('1a', 'Flutter & Dart SDK Setup', 'Environment information & checklist',
          Icons.install_desktop, (_) => const Exp1aSetupScreen()),
      _Exp('1b', 'Dart Language Basics', 'Variables, loops, functions',
          Icons.code, (_) => const Exp1bDartBasicsScreen()),
    ]),
    _Unit('Unit 2 - Widgets & Layouts', [
      _Exp('2a', 'Basic Widgets', 'Scaffold, Container, Text, Image',
          Icons.widgets, (_) => const Exp2aBasicWidgetsScreen()),
      _Exp('2b', 'Row, Column & Stack', 'Flexible layout structures',
          Icons.view_quilt, (_) => const Exp2bLayoutScreen()),
    ]),
    _Unit('Unit 3 - Responsive Design', [
      _Exp('3a', 'Responsive UI', 'LayoutBuilder adaptive layout',
          Icons.devices, (_) => const Exp3aResponsiveScreen()),
      _Exp('3b', 'MediaQuery & Breakpoints', 'Screen metrics & breakpoints',
          Icons.aspect_ratio, (_) => const Exp3bMediaQueryScreen()),
    ]),
    _Unit('Unit 4 - Navigation', [
      _Exp('4a', 'Navigator Push / Pop', 'Basic navigation & data passing',
          Icons.swap_horiz, (_) => const Exp4aHomeScreen()),
      _Exp('4b', 'Named Routes', 'Centralised route table',
          Icons.alt_route, (_) => const Exp4bFirstScreen()),
    ]),
    _Unit('Unit 5 - State Management', [
      _Exp('5a', 'Stateful vs Stateless', 'setState() counter',
          Icons.exposure_plus_1, (_) => const Exp5aCounterScreen()),
      _Exp('5b', 'Provider', 'ChangeNotifier + Provider',
          Icons.hub, (_) => const Exp5bProviderScreen()),
    ]),
    _Unit('Unit 6 - Custom Widgets & Themes', [
      _Exp('6a', 'Custom Widgets', 'Reusable CustomCardTile',
          Icons.dashboard_customize, (_) => const Exp6aCustomWidgetScreen()),
      _Exp('6b', 'Themes & Styles', 'ThemeData light/dark',
          Icons.palette, (_) => const Exp6bThemeScreen()),
    ]),
    _Unit('Unit 7 - Forms', [
      _Exp('7a', 'Form Input Fields', 'TextFormField, Switch, Checkbox',
          Icons.edit_note, (_) => const Exp7aFormScreen()),
      _Exp('7b', 'Form Validation', 'GlobalKey<FormState> + validator',
          Icons.rule, (_) => const Exp7bValidationScreen()),
    ]),
    _Unit('Unit 8 - Animations', [
      _Exp('8a', 'Explicit Animation', 'AnimationController + ScaleTransition',
          Icons.animation, (_) => const Exp8aAnimationScreen()),
      _Exp('8b', 'Implicit Animation', 'AnimatedOpacity / AnimatedContainer',
          Icons.blur_on, (_) => const Exp8bImplicitScreen()),
    ]),
    _Unit('Unit 9 - REST API', [
      _Exp('9a', 'Fetch from REST API', 'http.get + async/await + jsonDecode',
          Icons.cloud_download, (_) => const Exp9aFetchScreen()),
      _Exp('9b', 'API Data in ListView', 'ListView.builder with JSON list',
          Icons.list_alt, (_) => const Exp9bListScreen()),
    ]),
    _Unit('Unit 10 - Testing & Debugging', [
      _Exp('10a', 'Unit & Widget Tests', 'flutter_test',
          Icons.fact_check, (_) => const Exp10aTestScreen()),
      _Exp('10b', 'Debugging Tools', 'debugPrint, Inspector, DevTools',
          Icons.bug_report, (_) => const Exp10bDebugScreen()),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Lab - 20 Experiments')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          for (final unit in _units) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(unit.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                      fontSize: 15)),
            ),
            for (final e in unit.items)
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cs.primaryContainer,
                    child: Icon(e.icon, color: cs.onPrimaryContainer),
                  ),
                  title: Text('Exp ${e.id}  -  ${e.title}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(e.aim),
                  trailing: const Icon(Icons.play_circle_outline),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: e.builder)),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
