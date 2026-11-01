import 'package:flutter/material.dart';

/// EXPERIMENT 4a - Navigator.push() / Navigator.pop() with data passing.
class Exp4aHomeScreen extends StatelessWidget {
  const Exp4aHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const Exp4aDetailScreen(message: 'Hello from Home!')),
            );
          },
          child: const Text('Go to Details'),
        ),
      ),
    );
  }
}

class Exp4aDetailScreen extends StatelessWidget {
  final String message;
  const Exp4aDetailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Screen')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// EXPERIMENT 4b - Named routes (registered in MaterialApp.routes in main.dart).
class Exp4bFirstScreen extends StatelessWidget {
  static const routeName = '/exp4b-first';
  const Exp4bFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              Navigator.pushNamed(context, Exp4bSecondScreen.routeName),
          child: const Text('Launch Second Screen'),
        ),
      ),
    );
  }
}

class Exp4bSecondScreen extends StatelessWidget {
  static const routeName = '/exp4b-second';
  const Exp4bSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}
