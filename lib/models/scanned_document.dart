/// Data model for one scanned document (stored in SQLite).
class ScannedDocument {
  final int? id;
  final String title;
  final String imagePath;
  final String extractedText;
  final String createdAt; // ISO-8601
  final String category;
  final bool isFavorite;

  const ScannedDocument({
    this.id,
    required this.title,
    required this.imagePath,
    required this.extractedText,
    required this.createdAt,
    this.category = 'General',
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'imagePath': imagePath,
        'extractedText': extractedText,
        'createdAt': createdAt,
        'category': category,
        'favorite': isFavorite ? 1 : 0,
      };

  factory ScannedDocument.fromMap(Map<String, dynamic> map) {
    return ScannedDocument(
      id: map['id'] as int?,
      title: map['title'] as String,
      imagePath: map['imagePath'] as String,
      extractedText: map['extractedText'] as String,
      createdAt: map['createdAt'] as String,
      category: (map['category'] as String?) ?? 'General',
      isFavorite: ((map['favorite'] as int?) ?? 0) == 1,
    );
  }

  ScannedDocument copyWith({
    int? id,
    String? title,
    String? imagePath,
    String? extractedText,
    String? createdAt,
    String? category,
    bool? isFavorite,
  }) {
    return ScannedDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      extractedText: extractedText ?? this.extractedText,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  int get wordCount {
    final t = extractedText.trim();
    return t.isEmpty ? 0 : t.split(RegExp(r'\s+')).length;
  }
}
