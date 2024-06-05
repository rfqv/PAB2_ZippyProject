import 'package:flutter/material.dart';

class UserFollowingListScreen extends StatelessWidget {
  const UserFollowingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simpan data following di sini. Gantikan dengan data yang sebenarnya.
    final List<String> following = ['Following 1', 'Following 2', 'Following 3'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
        backgroundColor: const Color(0xFF7DABCF),
      ),
      body: ListView.builder(
        itemCount: following.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(following[index]),
          );
        },
      ),
    );
  }
}
