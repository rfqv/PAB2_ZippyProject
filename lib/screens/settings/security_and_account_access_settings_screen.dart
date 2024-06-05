import 'package:flutter/material.dart';

class SecurityAndAccountAccessSettings extends StatelessWidget {
  const SecurityAndAccountAccessSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Security and Account Access',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: const Center(
        child: Text('Security and Account Access Settings'),
      ),
    );
  }
}
