import 'dart:developer' as developer;

import 'package:flutter/material.dart';

/// EXPERIMENT 10a - Unit & widget tests live in test/widget_test.dart.
/// This screen shows what is tested and how to run it.
class Exp10aTestScreen extends StatelessWidget {
  const Exp10aTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tests = [
      'ScannedDocument toMap/fromMap round-trip (unit test)',
      'ScannedDocument word count (unit test)',
      'CustomCardTile shows title and subtitle (widget test)',
      'Counter text test from the lab manual (widget test)',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Exp 10a - Unit & Widget Tests')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '\$ flutter test\n00:03 +4: All tests passed!',
              style: TextStyle(
                  color: Color(0xFF7CFC9A), fontFamily: 'monospace', height: 1.6),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Test cases in test/widget_test.dart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          for (final t in tests)
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(t),
            ),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
                'Run them in the terminal with:  flutter test',
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }
}

/// EXPERIMENT 10b - Debugging: debugPrint, dart:developer log, try/catch,
/// Flutter Inspector and DevTools.
class Exp10bDebugScreen extends StatefulWidget {
  const Exp10bDebugScreen({super.key});

  @override
  State<Exp10bDebugScreen> createState() => _Exp10bDebugScreenState();
}

class _Exp10bDebugScreenState extends State<Exp10bDebugScreen> {
  final List<String> _logs = [];

  void _log(String msg) {
    debugPrint(msg); // shows in the Debug Console / DevTools Logging tab
    developer.log(msg, name: 'DocScan');
    setState(() => _logs.insert(0, '[${TimeOfDay.now().format(context)}] $msg'));
  }

  void _simulateError() {
    try {
      final list = <int>[1, 2, 3];
      // ignore: unnecessary_statements
      list[10];
    } catch (e, st) {
      _log('Caught error: $e');
      debugPrint('$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exp 10b - Debugging Tools')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                    onPressed: () => _log('Button pressed - debugPrint()'),
                    child: const Text('debugPrint')),
                ElevatedButton(
                    onPressed: _simulateError,
                    child: const Text('Simulate error')),
                OutlinedButton(
                    onPressed: () => setState(_logs.clear),
                    child: const Text('Clear')),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Console output (also visible in DevTools)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  children: [
                    for (final l in _logs)
                      Text(l,
                          style: const TextStyle(
                              color: Color(0xFF7CFC9A),
                              fontFamily: 'monospace')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tip: run  flutter run  then press  v  to open DevTools, and '
              'enable "Select Widget Mode" in the Flutter Inspector.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
