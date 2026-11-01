import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// EXPERIMENT 1a - Installation of Flutter & Dart SDK.
/// This screen proves the installation works: it reads the Dart runtime and
/// the OS details and lists the setup checklist from the lab manual.
class Exp1aSetupScreen extends StatelessWidget {
  const Exp1aSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Operating system', Platform.operatingSystem),
      MapEntry('OS version', Platform.operatingSystemVersion),
      MapEntry('Dart runtime', Platform.version.split(' ').first),
      MapEntry('Build mode',
          kReleaseMode ? 'Release' : (kProfileMode ? 'Profile' : 'Debug')),
      MapEntry('Processors', '${Platform.numberOfProcessors}'),
    ];
    const steps = [
      'Download Flutter SDK from flutter.dev',
      'Extract it (e.g. C:\\src\\flutter)',
      'Add flutter\\bin to the PATH variable',
      'Run  flutter doctor  in the terminal',
      'Install VS Code / Android Studio + Flutter & Dart plugins',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Exp 1a - Flutter & Dart Setup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Flutter is installed and running!',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Runtime information of this device'),
                ),
                for (final r in rows)
                  ListTile(
                    dense: true,
                    title: Text(r.key),
                    trailing: Text(r.value),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('Setup checklist',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          for (var i = 0; i < steps.length; i++)
            ListTile(
              leading: CircleAvatar(radius: 14, child: Text('${i + 1}')),
              title: Text(steps[i]),
            ),
        ],
      ),
    );
  }
}

/// EXPERIMENT 1b - Dart language basics. The very same program as
/// dart_basics/basics.dart; here its output is shown inside the app.
List<String> runDartBasics() {
  final out = <String>[];
  void print(Object? o) => out.add('$o');

  int addNumbers(int a, int b) => a + b;

  String topic = 'Dart Basics';
  int year = 2026;
  print('Welcome to $topic ($year)');
  if (year >= 2026) {
    print('Modern Dart with Null Safety.');
  }
  List<String> fruits = ['Apple', 'Banana', 'Orange'];
  for (var fruit in fruits) {
    print('Fruit: $fruit');
  }
  print('Sum: ${addNumbers(10, 20)}');
  return out;
}

class Exp1bDartBasicsScreen extends StatefulWidget {
  const Exp1bDartBasicsScreen({super.key});

  @override
  State<Exp1bDartBasicsScreen> createState() => _Exp1bDartBasicsScreenState();
}

class _Exp1bDartBasicsScreenState extends State<Exp1bDartBasicsScreen> {
  List<String> _output = runDartBasics();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exp 1b - Dart Basics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Output of  dart run basics.dart',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _output.map((l) => '> $l').join('\n'),
                style: const TextStyle(
                    color: Color(0xFF7CFC9A), fontFamily: 'monospace', height: 1.6),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => setState(() => _output = runDartBasics()),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Run again'),
            ),
          ],
        ),
      ),
    );
  }
}
