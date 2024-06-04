import 'package:flutter/material.dart';

class PrivacyAndSafetySettings extends StatelessWidget {
  const PrivacyAndSafetySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and Safety'),
        backgroundColor: const Color(0xFF7DABCF),
      ),
      body: const Center(
        child: Text('Privacy and Safety Settings'),
      ),
    );
  }
}
