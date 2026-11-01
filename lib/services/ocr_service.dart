import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Google ML Kit on-device text recognition (no internet needed).
class OcrService {
  final TextRecognizer _recognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> extractText(File imageFile) async {
    final input = InputImage.fromFile(imageFile);
    final RecognizedText result = await _recognizer.processImage(input);
    return result.text;
  }

  void close() => _recognizer.close();
}
