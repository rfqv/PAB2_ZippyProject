import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ThreadImageQuote extends StatefulWidget {
  const ThreadImageQuote({super.key});

  Future<void> uploadImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final file = File(pickedFile.path);
    final storageRef = FirebaseStorage.instance.ref().child('thread_images/${DateTime.now()}.jpg');
    final uploadTask = storageRef.putFile(file);

    await uploadTask.whenComplete(() {
      print('Image uploaded successfully');
    });
  } else {
    print('No image selected');
  }
}
  @override
  State<ThreadImageQuote> createState() => _ThreadImageQuoteState();
}

class _ThreadImageQuoteState extends State<ThreadImageQuote> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
