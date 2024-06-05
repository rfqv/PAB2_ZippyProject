import 'package:flutter/material.dart';

class UserFansListScreen extends StatelessWidget {
  const UserFansListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simpan data fans di sini. Gantikan dengan data yang sebenarnya.
    final List<String> fans = ['Fan 1', 'Fan 2', 'Fan 3'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fans'),
        backgroundColor: const Color(0xFF7DABCF),
      ),
      body: ListView.builder(
        itemCount: fans.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(fans[index]),
          );
        },
      ),
    );
  }
}
