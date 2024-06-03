import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
      if (_selectedImage != null) {
        final imageUrl = await _uploadImage(_selectedImage!);
        final quoteText = _quoteController.text;

        final firstTweet = Cuitan(
          text: '', 
          userId: 'your_user_id', 
          timestamp: DateTime.now(),
          imageUrl: imageUrl,
        );

        final secondTweet = Cuitan(
          text: quoteText,
          userId: 'your_user_id', 
          timestamp: DateTime.now(),
          isQuote: true, 
          quoteTweetId: firstTweet.id, 
        );

        await FirebaseFirestore.instance.collection('Cuitan').add(firstTweet.toJson());
        await FirebaseFirestore.instance.collection('Cuitan').add(secondTweet.toJson());

        Navigator.pop(context);
      }
    }
  }

  Future<String> _uploadImage(XFile imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child('Cuitan').child(DateTime.now().toString());
    final uploadTask = storageRef.putFile(imageFile);
    await uploadTask.whenComplete(() async {
      return await storageRef.getDownloadURL();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quote Thread'),
        actions: [
          TextButton(
            onPressed: _createThread,
            child: const Text('Post'),
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
            ],
          ),
        ),
      ),
    );
  }
}