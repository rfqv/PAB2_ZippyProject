import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:zippy/screens/profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _userGender;
  File? _imageFile;
  bool _showAdditionalFields = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = snapshot.snapshot.value as Map?;
        setState(() {
          _nameController.text = data?['profileName'] ?? '';
          _bioController.text = data?['userBio'] ?? '';
          _birthdayController.text = data?['userBirthday'] ?? '01-01-1970';
          _addressController.text = data?['userAddress'] ?? '';
          _usernameController.text = data?['username'] ?? '';
          _emailController.text = user.email ?? '';
          _userGender = data?['userGender'];
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      await ref.update({
        'profileName': _nameController.text,
        'userBio': _bioController.text,
        'userBirthday': _birthdayController.text,
        'userAddress': _addressController.text,
        'username': _usernameController.text,
        'userGender': _userGender,
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Berhasil menyimpan perubahan!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Profile()));
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Kembali'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : const AssetImage('assets/me/default_profileImage.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(controller: _nameController, label: 'Nama'),
            _buildTextField(controller: _bioController, label: 'Bio'),
            _buildTextField(controller: _birthdayController, label: 'Tanggal Lahir'),
            _buildTextField(controller: _addressController, label: 'Alamat'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Laki-Laki'),
                    value: 'Laki-Laki',
                    groupValue: _userGender,
                    onChanged: (String? value) {
                      setState(() {
                        _userGender = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Perempuan'),
                    value: 'Perempuan',
                    groupValue: _userGender,
                    onChanged: (String? value) {
                      setState(() {
                        _userGender = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _showAdditionalFields = !_showAdditionalFields;
                });
              },
              child: const Text('Lanjutan'),
            ),
            if (_showAdditionalFields) ...[
              _buildTextField(controller: _usernameController, label: 'Username'),
              _buildTextField(controller: _emailController, label: 'Email'),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: '$label :',
        ),
      ),
    );
  }
}
