import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:zippy/screens/main_session/profile.dart';

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
  String? _profileImageUrl;
  bool _showAdditionalFields = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _getCurrentLocation();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = snapshot.snapshot.value as Map?;
        setState(() {
          UserProfile userProfile = UserProfile(
            profileName: data?['profileName'] ?? '',
            userBio: data?['userBio'] ?? '',
            userBirthday: data?['userBirthday'] ?? '01-01-1970',
            userAddress: data?['userAddress'] ?? '',
            username: data?['username'] ?? '',
            userEmail: user.email ?? '',
            userGender: data?['userGender'],
            profileImage: data?['profileImage'] ?? 'assets/me/default_profileImage.png',
          );

          _nameController.text = userProfile.profileName;
          _bioController.text = userProfile.userBio;
          _birthdayController.text = userProfile.userBirthday;
          _addressController.text = userProfile.userAddress;
          _usernameController.text = userProfile.username;
          _emailController.text = userProfile.userEmail;
          _userGender = userProfile.userGender;
          _profileImageUrl = userProfile.profileImage;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? imageUrl;
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child('user_profileImage/${_usernameController.text}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = await storageRef.putFile(_imageFile!);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }
      
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      await ref.update({
        'profileImage': imageUrl ?? _profileImageUrl,
        'profileName': _nameController.text,
        'userBio': _bioController.text,
        'userBirthday': _birthdayController.text,
        'userAddress': _addressController.text,
        'username': _usernameController.text,
        'userGender': _userGender,
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
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

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    if (await Permission.location.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = position;
        });
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      await Permission.location.request();
    }
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
                backgroundImage: _imageFile != null 
        ? FileImage(_imageFile!) 
        : (_profileImageUrl != null && _profileImageUrl!.startsWith('http'))
            ? NetworkImage(_profileImageUrl!) 
            : const AssetImage('assets/me/default_profileImage.png') as ImageProvider,
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
            if (_currentPosition != null) ...[
              Text('Latitude: ${_currentPosition?.latitude}, Longitude: ${_currentPosition?.longitude}'),
            ]
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

class UserProfile {
  String profileName;
  String userBio;
  String userBirthday;
  String userAddress;
  String username;
  String userEmail;
  String? userGender;
  String profileImage;

  UserProfile({
    required this.profileName,
    required this.userBio,
    required this.userBirthday,
    required this.userAddress,
    required this.username,
    required this.userEmail,
    this.userGender,
    required this.profileImage,
  });
}
