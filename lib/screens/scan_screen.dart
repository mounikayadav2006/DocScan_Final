import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/scanned_document.dart';
import '../services/ocr_service.dart';

/// Capture -> OCR -> Save.
/// EXPERIMENT 7a: form with TextFormField, ChoiceChip, Switch, Checkbox.
/// EXPERIMENT 7b: validation with GlobalKey<FormState> + validator.
/// EXPERIMENT 8b: AnimatedContainer step indicator (implicit animation).
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _ocr = OcrService();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  static const _categories = ['General', 'Notes', 'Receipt', 'ID', 'Book'];

  File? _imageFile;
  bool _busy = false;
  bool _hasExtracted = false;
  String _category = 'General';
  bool _favorite = false;
  bool _reviewed = false;
  bool _showCheckError = false;

  int get _step => _imageFile == null ? 0 : (_hasExtracted ? 2 : 1);

  @override
  void dispose() {
    _ocr.close();
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _capture(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source, imageQuality: 90);
    if (picked == null) return;
    setState(() {
      _imageFile = File(picked.path);
      _hasExtracted = false;
      _reviewed = false;
      _textController.clear();
      if (_titleController.text.isEmpty) {
        _titleController.text =
            'Document ${DateTime.now().toString().substring(0, 16)}';
      }
    });
  }

  Future<void> _runOcr() async {
    if (_imageFile == null) return;
    setState(() => _busy = true);
    try {
      final text = await _ocr.extractText(_imageFile!);
      setState(() {
        _textController.text = text;
        _hasExtracted = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('OCR failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please capture a photo first')));
      return;
    }
    setState(() => _showCheckError = !_reviewed);
    // EXPERIMENT 7b: trigger every validator in the form
    if (!_formKey.currentState!.validate() || !_reviewed) return;

    setState(() => _busy = true);
    final state = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'scan_${DateTime.now().millisecondsSinceEpoch}${p.extension(_imageFile!.path)}';
    final savedImage = await _imageFile!.copy(p.join(dir.path, fileName));

    await state.addDocument(ScannedDocument(
      title: _titleController.text.trim(),
      imagePath: savedImage.path,
      extractedText: _textController.text,
      createdAt: DateTime.now().toIso8601String(),
      category: _category,
      isFavorite: _favorite,
    ));

    navigator.pop();
    messenger.showSnackBar(
        const SnackBar(content: Text('Document saved successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Document')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _stepper(),
              const SizedBox(height: 16),
              _preview(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _capture(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _capture(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
              if (_imageFile != null) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                      labelText: 'Document Title',
                      prefixIcon: Icon(Icons.title)),
                  validator: (v) {
                    if (v == null || v.trim().length < 3) {
                      return 'Title must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                const Text('Category',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: _categories
                      .map((c) => ChoiceChip(
                            label: Text(c),
                            selected: _category == c,
                            onSelected: (_) => setState(() => _category = c),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _busy ? null : _runOcr,
                  icon: const Icon(Icons.text_snippet),
                  label: Text(_hasExtracted
                      ? 'Re-run Text Extraction'
                      : 'Extract Text (OCR)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _textController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                      labelText: 'Extracted Text (editable)',
                      alignLabelWithHint: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Run OCR first (or type the text manually)';
                    }
                    return null;
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Mark as favourite'),
                  secondary: const Icon(Icons.star_outline),
                  value: _favorite,
                  onChanged: (v) => setState(() => _favorite = v),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('I have reviewed the extracted text'),
                  subtitle: _showCheckError && !_reviewed
                      ? const Text('Please confirm before saving',
                          style: TextStyle(color: Colors.red))
                      : null,
                  value: _reviewed,
                  onChanged: (v) => setState(() => _reviewed = v ?? false),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _busy ? null : _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Document'),
                ),
              ],
              if (_busy) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepper() {
    const labels = ['Capture', 'Extract', 'Save'];
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(3, (i) {
        final active = i <= _step;
        return Expanded(
          // EXPERIMENT 8b: AnimatedContainer = implicit animation
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? cs.primary : cs.primaryContainer.withAlpha(120),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${i + 1}. ${labels[i]}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: active ? cs.onPrimary : cs.onPrimaryContainer,
                  fontWeight: FontWeight.w600),
            ),
          ),
        );
      }),
    );
  }

  Widget _preview() {
    if (_imageFile == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(50),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_a_photo_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('Capture or pick a document photo',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(_imageFile!, height: 260, fit: BoxFit.cover),
    );
  }
}
