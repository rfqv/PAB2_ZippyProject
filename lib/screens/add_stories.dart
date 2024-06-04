import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  XFile? _selectedImage;
  XFile? _selectedVideo;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  Future<void> _selectVideo() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _selectedVideo = pickedVideo;
    });
  }

  Future<void> _uploadStory() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage != null) {
        await _uploadImage(_selectedImage!);
      } else if (_selectedVideo != null) {
        await _uploadVideo(_selectedVideo!);
      }
      Navigator.pop(context);
    }
  }

  Future<void> _uploadImage(XFile imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child('stories').child(DateTime.now().toString());
    final uploadTask = storageRef.putFile(imageFile);
    await uploadTask.whenComplete(() async {
      final downloadUrl = await storageRef.getDownloadURL();
      await _createStory(downloadUrl, _textController.text, 'image');
    });
  }

  Future<void> _uploadVideo(XFile videoFile) async {
    final storageRef = FirebaseStorage.instance.ref().child('stories').child(DateTime.now().toString());
    final uploadTask = storageRef.putFile(videoFile);
    await uploadTask.whenComplete(() async {
      final downloadUrl = await storageRef.getDownloadURL();
      await _createStory(downloadUrl, _textController.text, 'video');
    });
  }

  Future<void> _createStory(String url, String text, String type) async {
    await FirebaseFirestore.instance.collection('stories').add({
      'url': url,
      'text': text,
      'type': type,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
        actions: [
          TextButton(
            onPressed: _uploadStory,
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
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Enter your story text',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _selectImage,
                    child: const Text('Select Image'),
                  ),
                  ElevatedButton(
                    onPressed: _selectVideo,
                    child: const Text('Select Video'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}