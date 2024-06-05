import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zippy/screens/sign_in/sign_in_screen.dart';

class PhoneNumberVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneNumberVerificationScreen({super.key, required this.phoneNumber});

  @override
  _PhoneNumberVerificationScreenState createState() => _PhoneNumberVerificationScreenState();
}

class _PhoneNumberVerificationScreenState extends State<PhoneNumberVerificationScreen> {
  final _codeController = TextEditingController();
  String? _verificationId;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  void _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _showSuccessMessage();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _errorMessage = e.message ?? 'Verification failed';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text("You're successfully signed up!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 32.0),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  final credential = PhoneAuthProvider.credential(
                    verificationId: _verificationId!,
                    smsCode: _codeController.text,
                  );

                  await FirebaseAuth.instance.signInWithCredential(credential);
                  _showSuccessMessage();
                } catch (e) {
                  setState(() {
                    _errorMessage = 'Invalid verification code';
                  });
                }
              },
              child: const Text('Verify'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
