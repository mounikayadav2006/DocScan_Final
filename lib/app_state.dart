import 'package:flutter/material.dart';

import 'models/scanned_document.dart';
import 'services/database_helper.dart';

/// EXPERIMENT 5b - App-wide state with Provider (ChangeNotifier).
/// Holds the theme (Exp 6b) and the list of scanned documents.
class AppState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  Color seed = const Color(0xFF00897B);

  List<ScannedDocument> documents = [];
  bool loading = true;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      documents = await DatabaseHelper.instance.getAllDocuments();
    } catch (e) {
      debugPrint('DB load failed: $e');
    }
    loading = false;
    notifyListeners();
  }

  Future<void> addDocument(ScannedDocument d) async {
    await DatabaseHelper.instance.insertDocument(d);
    await load();
  }

  Future<void> deleteDocument(int id) async {
    await DatabaseHelper.instance.deleteDocument(id);
    await load();
  }

  Future<ScannedDocument> toggleFavorite(ScannedDocument d) async {
    final updated = d.copyWith(isFavorite: !d.isFavorite);
    await DatabaseHelper.instance.updateDocument(updated);
    await load();
    return updated;
  }

  void setDark(bool value) {
    themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSeed(Color c) {
    seed = c;
    notifyListeners();
  }

  int get totalWords => documents.fold(0, (s, d) => s + d.wordCount);
  int get favoriteCount => documents.where((d) => d.isFavorite).length;
}
