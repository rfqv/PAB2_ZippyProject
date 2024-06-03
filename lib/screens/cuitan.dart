import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCuitanScreen extends StatefulWidget {
  const AddCuitanScreen({Key? key}) : super(key: key);

  @override
  State<AddCuitanScreen> createState() => _AddCuitanScreenState();
}

class _AddCuitanScreenState extends State<AddCuitanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cuitanController = TextEditingController();

  Future<void> _addTweet() async {
    if (_formKey.currentState!.validate()) {
      final cuitanText = _cuitanController.text;
      final newCuitan = Cuitan(
        text: cuitanText,
        userId: 'your_user_id', // kasih nama ID user nya
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('cuitan')
          .add(newCuitan.toJson());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Cuitan'),
        actions: [
          TextButton(
            onPressed: _addTweet,
            child: const Text(
              'Cuitan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            controller: _cuitanController,
            decoration: const InputDecoration(
              hintText: 'What\'s happening?',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a ppy';
              }
              return null;
            },
            maxLines: null,
          ),
        ),
      ),
    );
  }
}

class Cuitan {
  final String text;
  final String userId;
  final DateTime timestamp;

  Cuitan({
    required this.text,
    required this.userId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'userId': userId,
      'timestamp': timestamp,
    };
  }
}
