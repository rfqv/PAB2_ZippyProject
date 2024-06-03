import 'package:flutter/material.dart';

class LupaPasswordScreen extends StatelessWidget {
  const LupaPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Kirim kode ke Email untuk reset password'),
              onTap: () {
                // Navigasi ke halaman reset password via email
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Masukkan pertanyaan rahasia'),
              onTap: () {
                // Navigasi ke halaman pertanyaan rahasia
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Hubungi developer'),
              onTap: () {
                // Navigasi ke halaman kontak developer
              },
            ),
          ],
        ),
      ),
    );
  }
}
