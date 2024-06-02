import 'package:flutter/material.dart';

class UserLocationScreen extends StatelessWidget {
  const UserLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Location'),
      ),
      body: Column(
        children: [
          Container(
            height: 400, // Adjust height as needed
            color: Colors.blue, // Placeholder for Google Maps
            child: const Center(child: Text('Google Maps here')),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement Google Maps redirection
            },
            child: const Text('Lihat di Maps'),
          ),
        ],
      ),
    );
  }
}
