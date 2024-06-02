import 'package:flutter/material.dart';

class AccessibilityDisplayAndLanguagesSettings extends StatefulWidget {
  const AccessibilityDisplayAndLanguagesSettings({super.key});

  @override
  _AccessibilityDisplayAndLanguagesSettingsState createState() => _AccessibilityDisplayAndLanguagesSettingsState();
}

class _AccessibilityDisplayAndLanguagesSettingsState extends State<AccessibilityDisplayAndLanguagesSettings> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accessibility, Display, and Languages'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Light Mode'),
            leading: Radio(
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                setState(() {
                  _themeMode = value!;
                  // Add theme change logic here
                });
              },
            ),
          ),
          ListTile(
            title: Text('Dark Mode'),
            leading: Radio(
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                setState(() {
                  _themeMode = value!;
                  // Add theme change logic here
                });
              },
            ),
          ),
          ListTile(
            title: Text('Default (User Preferences)'),
            leading: Radio(
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                setState(() {
                  _themeMode = value!;
                  // Add theme change logic here
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
