import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/scanned_document.dart';

/// Builds a PDF (scanned image + OCR text) and saves it in app storage.
class PdfService {
  Future<File> generatePdf(ScannedDocument doc) async {
    final pdf = pw.Document();
    final bytes = await File(doc.imagePath).readAsBytes();
    final image = pw.MemoryImage(bytes);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: doc.title),
          pw.Text('Category: ${doc.category}',
              style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 12),
          pw.Image(image, height: 260, fit: pw.BoxFit.contain),
          pw.SizedBox(height: 16),
          pw.Text('Extracted Text:',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          pw.SizedBox(height: 6),
          pw.Text(
            doc.extractedText.isEmpty ? '(No text detected)' : doc.extractedText,
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final safe = doc.title.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final file = File('${dir.path}/$safe.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
