import 'package:flutter/material.dart';

class PrivacyAndSafetySettings extends StatelessWidget {
  const PrivacyAndSafetySettings({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy and Safety',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: const Center(
        child: Text('Privacy and Safety Settings'),
      ),
    );
  }
}
