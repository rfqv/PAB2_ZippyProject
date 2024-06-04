import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCuitanScreen extends StatefulWidget {
  const AddCuitanScreen({super.key});

  @override
  State<AddCuitanScreen> createState() => _AddCuitanScreenState();
}

class _AddCuitanScreenState extends State<AddCuitanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _CuitanController = TextEditingController();

  Future<void> _addTweet() async {
    if (_formKey.currentState!.validate()) {
      final cuitanText = _CuitanController.text;
      final newcuitan = Cuitan(
        text: cuitanText,
        userId: 'your_user_id', 
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('cuitan').add(newcuitan.toJson());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add cuitan'),
        actions: [
          TextButton(
            onPressed: _addTweet,
            child: const Text('Cuitan'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            controller: _CuitanController,
            decoration: const InputDecoration(
              hintText: 'What\'s happening?',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a tweet';
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

