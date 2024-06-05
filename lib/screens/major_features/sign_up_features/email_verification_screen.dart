import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zippy/screens/major_features/sign_up_features/phone_number_input_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;

  const EmailVerificationScreen({super.key, required this.user});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  String _errorMessage = '';
  bool _isEmailVerified = false;
  bool _isSendingVerificationEmail = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();
  }

  Future<void> _checkEmailVerified() async {
    await widget.user.reload();
    setState(() {
      _isEmailVerified = widget.user.emailVerified;
    });

    if (_isEmailVerified) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => PhoneNumberInputScreen(user: widget.user)),
      );
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      setState(() {
        _isSendingVerificationEmail = true;
      });

      await widget.user.sendEmailVerification();

      setState(() {
        _isSendingVerificationEmail = false;
        _errorMessage = 'Verification email has been sent. Please check your email.';
      });
    } catch (error) {
      setState(() {
        _isSendingVerificationEmail = false;
        _errorMessage = error.toString();
      });
    }
  }

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
              if (_isEmailVerified)
                const Text(
                  'Your email is verified. Redirecting...',
                  style: TextStyle(color: Colors.green),
                )
              else
                Column(
                  children: [
                    const Text(
                      'A verification link has been sent to your email. Please check your email and verify.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _isSendingVerificationEmail ? null : _sendVerificationEmail,
                      child: _isSendingVerificationEmail
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Resend Verification Email'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _checkEmailVerified,
                      child: const Text('I have verified my email'),
                    ),
                  ],
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
