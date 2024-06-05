import 'package:flutter/material.dart';

class SecurityAndAccountAccessSettings extends StatelessWidget {
  const SecurityAndAccountAccessSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security and Account Access'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: const Center(
        child: Text('Security and Account Access Settings'),
      ),
    );
  }
}
