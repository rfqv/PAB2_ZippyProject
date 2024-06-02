import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zippy/screens/sign_out_screen.dart';

class YourAccountSettings extends StatelessWidget {
  const YourAccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignOutScreen()),
            );
          },
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
