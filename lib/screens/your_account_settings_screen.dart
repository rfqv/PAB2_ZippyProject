import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class YourAccountSettings extends StatelessWidget {
  const YourAccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Account'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
