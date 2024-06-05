import 'package:flutter/material.dart';

class UserPpyListScreen extends StatelessWidget {
  const UserPpyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simpan data Ppy di sini. Gantikan dengan data yang sebenarnya.
    final List<String> ppy = ['Ppy 1', 'Ppy 2', 'Ppy 3'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ppy'),
        backgroundColor: const Color(0xFF7DABCF),
      ),
      body: ListView.builder(
        itemCount: ppy.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(ppy[index]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                ],
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
