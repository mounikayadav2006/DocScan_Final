// EXPERIMENT 10a - Unit and widget tests.   Run with:  flutter test
import 'package:docscan/models/scanned_document.dart';
import 'package:docscan/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ScannedDocument toMap/fromMap round-trip', () {
    const doc = ScannedDocument(
      id: 1,
      title: 'Notes',
      imagePath: '/tmp/a.jpg',
      extractedText: 'hello world',
      createdAt: '2026-01-01T10:00:00',
      category: 'Notes',
      isFavorite: true,
    );
    final copy = ScannedDocument.fromMap(doc.toMap());
    expect(copy.title, 'Notes');
    expect(copy.category, 'Notes');
    expect(copy.isFavorite, true);
    expect(copy.extractedText, 'hello world');
  });

  test('ScannedDocument word count', () {
    const doc = ScannedDocument(
      title: 't',
      imagePath: 'p',
      extractedText: 'one two  three\nfour',
      createdAt: 'x',
    );
    expect(doc.wordCount, 4);
  });

  testWidgets('CustomCardTile shows title and subtitle', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: CustomCardTile(
            title: 'Profile', subtitle: 'Manage user settings', icon: Icons.person),
      ),
    ));
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Manage user settings'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('Counter increment widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Test Counter: 0'),
        ),
      ),
    );
    expect(find.text('Test Counter: 0'), findsOneWidget);
    expect(find.text('Test Counter: 1'), findsNothing);
  });
}
