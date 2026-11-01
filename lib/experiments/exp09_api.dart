import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// EXPERIMENT 9a - Fetch one JSON object from a REST API.
class Exp9aFetchScreen extends StatefulWidget {
  const Exp9aFetchScreen({super.key});

  @override
  State<Exp9aFetchScreen> createState() => _Exp9aFetchScreenState();
}

class _Exp9aFetchScreenState extends State<Exp9aFetchScreen> {
  late final Future<String> _future = fetchData();

  Future<String> fetchData() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['title'] as String;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REST API Fetch')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<String>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Title: ${snapshot.data}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

/// EXPERIMENT 9b - JSON list in ListView.builder.
class Exp9bListScreen extends StatefulWidget {
  const Exp9bListScreen({super.key});

  @override
  State<Exp9bListScreen> createState() => _Exp9bListScreenState();
}

class _Exp9bListScreenState extends State<Exp9bListScreen> {
  late final Future<List<dynamic>> _future = fetchUsers();

  Future<List<dynamic>> fetchUsers() async {
    final res =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    return jsonDecode(res.body) as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API ListView Display')),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(snapshot.data![index]['name'] as String),
                subtitle: Text(snapshot.data![index]['email'] as String),
              );
            },
          );
        },
      ),
    );
  }
}
