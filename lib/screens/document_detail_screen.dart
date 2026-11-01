import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../app_state.dart';
import '../models/scanned_document.dart';
import '../services/pdf_service.dart';

/// EXPERIMENT 4a: receives the document through the constructor (data
/// passing) and returns with Navigator.pop().
class DocumentDetailScreen extends StatefulWidget {
  final ScannedDocument document;
  const DocumentDetailScreen({super.key, required this.document});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  late ScannedDocument _doc = widget.document;
  bool _exporting = false;

  Future<void> _exportPdf() async {
    setState(() => _exporting = true);
    try {
      final file = await PdfService().generatePdf(_doc);
      await Share.shareXFiles([XFile(file.path)],
          text: 'Exported from DocScan: ${_doc.title}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('PDF export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _delete() async {
    final state = context.read<AppState>();
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete document?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true && _doc.id != null) {
      await state.deleteDocument(_doc.id!);
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_doc.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(_doc.isFavorite ? Icons.star : Icons.star_outline),
            onPressed: () async {
              final updated = await context.read<AppState>().toggleFavorite(_doc);
              setState(() => _doc = updated);
            },
          ),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: _delete),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'doc-${_doc.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(_doc.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: cs.primaryContainer,
                      child: const Icon(Icons.image_not_supported, size: 48)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                    avatar: const Icon(Icons.category, size: 16),
                    label: Text(_doc.category)),
                Chip(
                    avatar: const Icon(Icons.text_fields, size: 16),
                    label: Text('${_doc.wordCount} words')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Extracted Text',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy text',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _doc.extractedText));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Text copied to clipboard')));
                  },
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withAlpha(90),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                  _doc.extractedText.isEmpty ? '(No text detected)' : _doc.extractedText),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _exporting ? null : _exportPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: Text(_exporting ? 'Exporting...' : 'Export as PDF'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              // EXPERIMENT 4a: Navigator.pop() to go back
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Documents'),
            ),
          ],
        ),
      ),
    );
  }
}
