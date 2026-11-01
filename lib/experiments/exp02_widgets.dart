import 'package:flutter/material.dart';

/// EXPERIMENT 2a - Basic widgets: Scaffold, Container, Text, Image.
class Exp2aBasicWidgetsScreen extends StatelessWidget {
  const Exp2aBasicWidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Widgets Demo')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Hello, Flutter!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Image.network(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                height: 120,
                errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image, size: 80, color: Colors.grey),
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// EXPERIMENT 2b - Layouts with Row, Column and Stack.
class Exp2bLayoutScreen extends StatelessWidget {
  const Exp2bLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row, Column & Stack')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.star, color: Colors.orange, size: 40),
              Icon(Icons.favorite, color: Colors.red, size: 40),
              Icon(Icons.thumb_up, color: Colors.blue, size: 40),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(width: 150, height: 150, color: Colors.blue),
              Container(width: 100, height: 100, color: Colors.yellow),
              const Text('Stacked Text',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Positioned(
                top: 4,
                right: 4,
                child: Icon(Icons.push_pin, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
