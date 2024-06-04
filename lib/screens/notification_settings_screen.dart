import 'package:flutter/material.dart';

class NotificationSettings extends StatelessWidget {
  const NotificationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        backgroundColor: const Color(0xFF7DABCF),
      ),
      body: const Center(
        child: Text('Notification Settings'),
      ),
    );
  }
}
