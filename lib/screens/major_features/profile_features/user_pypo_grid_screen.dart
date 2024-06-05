import 'package:flutter/material.dart';

class UserPypoGridScreen extends StatelessWidget {
  const UserPypoGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simpan data Pypo di sini. Gantikan dengan data yang sebenarnya.
    final List<String> pypo = ['assets/image1.png', 'assets/image2.png', 'assets/image3.png'];

    if (pypo.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pypo'),
        ),
        body: const Center(
          child: Text("Tidak ada Pypo"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pypo'),
        backgroundColor: const Color(0xFF7DABCF),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: pypo.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Implementasikan navigasi ke layar detail Pypo jika diperlukan
            },
            child: Image.asset(pypo[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
