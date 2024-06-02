import 'package:flutter/material.dart';

class UserSavedScreen extends StatelessWidget {
  const UserSavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tersimpan'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Lihat Pypo Tersimpan'),
            onTap: () {
              // Navigate to saved Pypo screen
            },
          ),
          ListTile(
            title: const Text('Lihat Ppy Tersimpan'),
            onTap: () {
              // Navigate to saved Ppy screen
            },
          ),
        ],
      ),
    );
  }
}
