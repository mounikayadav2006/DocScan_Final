import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// EXPERIMENT 5a - StatefulWidget + setState().
class Exp5aCounterScreen extends StatefulWidget {
  const Exp5aCounterScreen({super.key});

  @override
  State<Exp5aCounterScreen> createState() => _Exp5aCounterScreenState();
}

class _Exp5aCounterScreenState extends State<Exp5aCounterScreen> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateful Counter')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Stateless text: this never changes'),
            const SizedBox(height: 16),
            Text('Counter: $_counter', style: const TextStyle(fontSize: 28)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// EXPERIMENT 5b - Provider + ChangeNotifier.
class CounterModel extends ChangeNotifier {
  int count = 0;
  void increment() {
    count++;
    notifyListeners();
  }
}

class Exp5bProviderScreen extends StatelessWidget {
  const Exp5bProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: const _ProviderBody(),
    );
  }
}

class _ProviderBody extends StatelessWidget {
  const _ProviderBody();

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Provider State Management')),
      body: Center(
        child: Text('Count: ${counter.count}',
            style: const TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterModel>().increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
