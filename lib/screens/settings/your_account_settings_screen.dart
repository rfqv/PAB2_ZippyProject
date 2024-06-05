import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zippy/screens/sign_out/sign_out_screen.dart';

class YourAccountSettings extends StatelessWidget {
  const YourAccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final buttonBackgroundColor = brightness == Brightness.dark ? const Color(0xFF555555) : const Color(0xFF7DABCF);
    final buttonTextColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    final elevatedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: buttonTextColor, // Font color
      backgroundColor: buttonBackgroundColor, // Background color
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Account',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Center(
        child: ElevatedButton(
          style: elevatedButtonStyle,
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
