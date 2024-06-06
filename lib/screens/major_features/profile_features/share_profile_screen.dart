import 'package:flutter/material.dart';
import 'package:zippy/screens/main_session/profile.dart';

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
