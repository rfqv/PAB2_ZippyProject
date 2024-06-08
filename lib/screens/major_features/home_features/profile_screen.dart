import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String profileName;
  final String profileImage;

  const ProfileScreen({
    Key? key,
    required this.username,
    required this.profileName,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$profileName\'s Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(height: 10),
            Text(
              profileName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '@$username',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            // Tambahkan informasi lainnya sesuai kebutuhan
          ],
        ),
      ),
    );
  }
}
