import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// EXPERIMENT 9a + 9b: fetch JSON from a REST API (http + async/await +
/// jsonDecode) and show it in ListView.builder.
class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  late Future<List<dynamic>> _future = _fetchTips();

  Future<List<dynamic>> _fetchTips() async {
    final res = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=20'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Failed to load tips (HTTP ${res.statusCode})');
  }

  Future<void> _refresh() async {
    setState(() => _future = _fetchTips());
    await _future.catchError((_) => <dynamic>[]);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Scanning Tips (REST API)')),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 56, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry')),
                  ],
                ),
              ),
            );
          }
          final items = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map<String, dynamic>;
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cs.primary,
                      child: Text('${index + 1}',
                          style: TextStyle(color: cs.onPrimary)),
                    ),
                    title: Text(
                      (item['title'] as String).toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text((item['body'] as String).replaceAll('\n', ' '),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
