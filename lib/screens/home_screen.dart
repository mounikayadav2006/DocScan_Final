import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/scanned_document.dart';
import '../widgets/custom_widgets.dart';
import 'document_detail_screen.dart';

/// Home: dashboard + responsive list/grid of scanned documents.
/// Uses: Provider (5b), Navigator.push (4a), named routes (4b),
/// responsive grid (3a/3b), custom widgets (6a), animations (8b).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final q = _query.toLowerCase();
    final docs = state.documents
        .where((d) =>
            d.title.toLowerCase().contains(q) ||
            d.extractedText.toLowerCase().contains(q) ||
            d.category.toLowerCase().contains(q))
        .toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(state)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    hintText: 'Search title, text or category',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            if (state.loading)
              const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()))
            else if (docs.isEmpty)
              SliverFillRemaining(hasScrollBody: false, child: _emptyState())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
                sliver: SliverGrid(
                  // Responsive: 1 column on phones, 2-3 on tablets (Exp 3a/3b)
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 480,
                    mainAxisExtent: 112,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _DocumentCard(document: docs[i]),
                    childCount: docs.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/scan'), // Exp 4b
        icon: const Icon(Icons.document_scanner),
        label: const Text('Scan Document'),
      ),
    );
  }

  Widget _buildHeader(AppState state) {
    return GradientHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.document_scanner, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text('DocScan',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Your pocket document scanner',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: [
              StatCard(
                  icon: Icons.description,
                  value: state.documents.length,
                  label: 'Documents'),
              StatCard(
                  icon: Icons.text_fields,
                  value: state.totalWords,
                  label: 'Words'),
              StatCard(
                  icon: Icons.star, value: state.favoriteCount, label: 'Starred'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Implicit animation (Exp 8b): the icon gently fades/scales in.
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.6, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutBack,
            builder: (context, v, child) =>
                Transform.scale(scale: v, child: child),
            child: Icon(Icons.document_scanner_outlined,
                size: 84, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          const Text('No documents yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Tap "Scan Document" to capture your first page.',
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final ScannedDocument document;
  const _DocumentCard({required this.document});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(document.createdAt);
    final dateLabel =
        date != null ? DateFormat('dd MMM yyyy, hh:mm a').format(date) : '';
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        // EXPERIMENT 4a: Navigator.push with data passing
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DocumentDetailScreen(document: document)),
        ),
        child: Row(
          children: [
            Hero(
              tag: 'doc-${document.id}',
              child: SizedBox(
                width: 100,
                height: double.infinity,
                child: Image.file(
                  File(document.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: cs.primaryContainer,
                    child: Icon(Icons.image_not_supported,
                        color: cs.onPrimaryContainer),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(document.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        if (document.isFavorite)
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      document.extractedText.isEmpty
                          ? 'No text detected'
                          : document.extractedText.replaceAll('\n', ' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(document.category,
                              style: TextStyle(
                                  fontSize: 11, color: cs.onPrimaryContainer)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(dateLabel,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
