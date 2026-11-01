import 'package:flutter/material.dart';

/// EXPERIMENT 7a - Form with various input fields.
class Exp7aFormScreen extends StatefulWidget {
  const Exp7aFormScreen({super.key});

  @override
  State<Exp7aFormScreen> createState() => _Exp7aFormScreenState();
}

class _Exp7aFormScreenState extends State<Exp7aFormScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  bool _acceptTerms = false;
  bool _newsletter = true;
  String _result = '';

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _username,
              decoration: const InputDecoration(
                  labelText: 'Username', prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
            ),
            Row(
              children: [
                const Text('Accept Terms:'),
                Switch(
                    value: _acceptTerms,
                    onChanged: (v) => setState(() => _acceptTerms = v)),
              ],
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Subscribe to newsletter'),
              value: _newsletter,
              onChanged: (v) => setState(() => _newsletter = v ?? false),
            ),
            ElevatedButton(
              onPressed: () => setState(() => _result =
                  'Username: ${_username.text}\nEmail: ${_email.text}\n'
                  'Terms: $_acceptTerms | Newsletter: $_newsletter'),
              child: const Text('Show entered data'),
            ),
            const SizedBox(height: 12),
            if (_result.isNotEmpty) Text(_result, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// EXPERIMENT 7b - Validation with GlobalKey<FormState>.
class Exp7bValidationScreen extends StatefulWidget {
  const Exp7bValidationScreen({super.key});

  @override
  State<Exp7bValidationScreen> createState() => _Exp7bValidationScreenState();
}

class _Exp7bValidationScreenState extends State<Exp7bValidationScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Validation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Enter Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
