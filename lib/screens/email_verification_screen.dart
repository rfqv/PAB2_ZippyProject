import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zippy/screens/phone_number_input_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;

  const EmailVerificationScreen({super.key, required this.user});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _verificationCodeController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              TextField(
                controller: _verificationCodeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (widget.user.emailVerified) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => PhoneNumberInputScreen(user: widget.user)),
                      );
                    } else {
                      setState(() {
                        _errorMessage = 'Please verify your email first.';
                      });
                    }
                  } catch (error) {
                    setState(() {
                      _errorMessage = error.toString();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_errorMessage),
                      ),
                    );
                  }
                },
                child: const Text('Verify Email'),
              ),
              const SizedBox(height: 16.0),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
