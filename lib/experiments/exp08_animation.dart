import 'package:flutter/material.dart';

/// EXPERIMENT 8a - Explicit animation (AnimationController).
class Exp8aAnimationScreen extends StatefulWidget {
  const Exp8aAnimationScreen({super.key});

  @override
  State<Exp8aAnimationScreen> createState() => _Exp8aAnimationScreenState();
}

class _Exp8aAnimationScreenState extends State<Exp8aAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explicit Animation')),
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(
              parent: _controller, curve: Curves.fastOutSlowIn),
          child: const FlutterLogo(size: 100),
        ),
      ),
    );
  }
}

/// EXPERIMENT 8b - Implicit animations (AnimatedOpacity, AnimatedContainer).
class Exp8bImplicitScreen extends StatefulWidget {
  const Exp8bImplicitScreen({super.key});

  @override
  State<Exp8bImplicitScreen> createState() => _Exp8bImplicitScreenState();
}

class _Exp8bImplicitScreenState extends State<Exp8bImplicitScreen> {
  bool _visible = true;
  bool _big = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Fade Animation')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: Container(width: 150, height: 150, color: Colors.purple),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => setState(() => _big = !_big),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutBack,
                width: _big ? 220 : 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _big ? Colors.orange : Colors.teal,
                  borderRadius: BorderRadius.circular(_big ? 50 : 8),
                ),
                alignment: Alignment.center,
                child: const Text('Tap me',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _visible = !_visible),
        child: const Icon(Icons.flip),
      ),
    );
  }
}
