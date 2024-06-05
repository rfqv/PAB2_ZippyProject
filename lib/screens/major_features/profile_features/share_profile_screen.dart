import 'package:flutter/material.dart';

class ShareProfileScreen extends StatelessWidget {
  const ShareProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bagikan Profil'),
      ),
      body: const Center(
        child: Text('Share Profile Page'),
      ),
    );
  }
}
