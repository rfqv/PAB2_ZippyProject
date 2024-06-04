import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AddQuoteThreadScreen extends StatefulWidget {
  const AddQuoteThreadScreen({super.key});

  @override
  State<AddQuoteThreadScreen> createState() => _AddQuoteThreadScreenState();
}

class _AddQuoteThreadScreenState extends State<AddQuoteThreadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quoteController = TextEditingController();
  XFile? _selectedImage;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  Future<void> _createThread() async {
    if (_formKey.currentState!.validate()) {
      final quoteText = _quoteController.text;
      String? imageUrl;

      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }

      final firstTweet = await _createCuitan(
          '', 'your_user_id', imageUrl); // ganti user id nya
      final secondTweet = await _createCuitan(
          quoteText, 'your_user_id', null, true, firstTweet); // ni juga

      Navigator.pop(context);
    }
  }

  Future<String> _uploadImage(XFile imageFile) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('Cuitan')
        .child(DateTime.now().toString());
    final uploadTask = storageRef.putFile(File(imageFile.path));
    await uploadTask.whenComplete(() {});
    return await storageRef.getDownloadURL();
  }

  Future<DocumentReference> _createCuitan(
      String text, String userId, String? imageUrl,
      [bool isQuote = false, DocumentReference? quoteTweetId]) async {
    final newCuitan = {
      'text': text,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
      'isQuote': isQuote,
      'quoteTweetId': quoteTweetId,
    };

    return await FirebaseFirestore.instance.collection('Cuitan').add(newCuitan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quote Thread'),
        actions: [
          TextButton(
            onPressed: _createThread,
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _quoteController,
                decoration: const InputDecoration(
                  hintText: 'Enter your quote',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quote';
                  }
                  return null;
                },
                maxLines: null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _selectImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 16.0),
              if (_selectedImage != null)
                Image.file(File(_selectedImage!.path)),
            ],
          ),
        ),
      ),
    );
  }
}
