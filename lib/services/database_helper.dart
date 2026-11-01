import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/scanned_document.dart';

/// Singleton wrapper around the local SQLite database (works fully offline).
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'docscan_pro.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE documents(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            imagePath TEXT NOT NULL,
            extractedText TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            category TEXT NOT NULL DEFAULT 'General',
            favorite INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertDocument(ScannedDocument doc) async {
    final db = await database;
    return db.insert('documents', doc.toMap()..remove('id'));
  }

  Future<List<ScannedDocument>> getAllDocuments() async {
    final db = await database;
    final rows = await db.query('documents', orderBy: 'createdAt DESC');
    return rows.map(ScannedDocument.fromMap).toList();
  }

  Future<int> updateDocument(ScannedDocument doc) async {
    final db = await database;
    return db.update('documents', doc.toMap(),
        where: 'id = ?', whereArgs: [doc.id]);
  }

  Future<int> deleteDocument(int id) async {
    final db = await database;
    return db.delete('documents', where: 'id = ?', whereArgs: [id]);
  }
}
