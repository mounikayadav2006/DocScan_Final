import 'package:flutter/material.dart';

/// EXPERIMENT 3a - Responsive UI with LayoutBuilder.
class Exp3aResponsiveScreen extends StatelessWidget {
  const Exp3aResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive UI')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Expanded(
                    child: Container(
                        color: Colors.lightBlue,
                        child: const Center(child: Text('Sidebar')))),
                Expanded(
                    flex: 2,
                    child: Container(
                        color: Colors.white,
                        child: const Center(child: Text('Main Content')))),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(
                    child: Container(
                        color: Colors.lightBlue,
                        child: const Center(child: Text('Header')))),
                Expanded(
                    flex: 2,
                    child: Container(
                        color: Colors.white,
                        child: const Center(child: Text('Main Content')))),
              ],
            );
          }
        },
      ),
    );
  }
}

/// EXPERIMENT 3b - MediaQuery & breakpoints. Rotate the phone to see it change.
class Exp3bMediaQueryScreen extends StatelessWidget {
  const Exp3bMediaQueryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenSize = mq.size;
    final isTablet = screenSize.width > 600;
    return Scaffold(
      appBar: AppBar(title: const Text('MediaQuery Demo')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
          decoration: BoxDecoration(
            color: isTablet ? Colors.teal.shade100 : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Screen Width: ${screenSize.width.toStringAsFixed(1)}\n'
            'Screen Height: ${screenSize.height.toStringAsFixed(1)}\n'
            'Orientation: ${mq.orientation.name}\n'
            'Pixel Ratio: ${mq.devicePixelRatio.toStringAsFixed(2)}\n'
            'Device Type: ${isTablet ? 'Tablet/Desktop' : 'Mobile'}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: isTablet ? 24 : 16, height: 1.6),
          ),
        ),
      ),
    );
  }
}
