import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/me/default_profileImages.jpeg'), // Update with your image
            ),
            const SizedBox(height: 10),
            const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(label: 'Name'),
            _buildTextField(label: 'Email'),
            _buildTextField(label: 'Bio'),
            _buildTextField(label: 'Date of birth'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Image.asset('assets/zippy.png',
                  width: 20, height: 20), // Update with your icon
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
              ),
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/zippy.png',
              width: 200,
              height: 200,
              color: Colors.black.withOpacity(0.1),
              colorBlendMode: BlendMode.dstIn,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: '$label :',
        ),
      ),
    );
  }
}
