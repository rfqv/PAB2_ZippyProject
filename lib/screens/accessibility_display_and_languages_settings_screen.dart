import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippy/services/user_settings_services.dart';

class AccessibilityDisplayAndLanguagesSettings extends StatefulWidget {
  const AccessibilityDisplayAndLanguagesSettings({super.key});

  @override
  _AccessibilityDisplayAndLanguagesSettingsState createState() => _AccessibilityDisplayAndLanguagesSettingsState();
}

class _AccessibilityDisplayAndLanguagesSettingsState extends State<AccessibilityDisplayAndLanguagesSettings> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en', 'US');

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<UserSettingsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility, Display, and Languages'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Light Mode'),
            leading: Radio(
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                setState(() {
                  _themeMode = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Dark Mode'),
            leading: Radio(
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                setState(() {
                  _themeMode = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Default (User Preferences)'),
            leading: Radio(
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                setState(() {
                  _themeMode = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Bahasa Indonesia'),
            leading: Radio(
              value: const Locale('id', 'ID'),
              groupValue: _locale,
              onChanged: (Locale? value) {
                setState(() {
                  _locale = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('English'),
            leading: Radio(
              value: const Locale('en', 'US'),
              groupValue: _locale,
              onChanged: (Locale? value) {
                setState(() {
                  _locale = value!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              settings.updateThemeMode(_themeMode);
              settings.updateLocale(_locale);
            },
            child: const Text('Apply & Save'),
          ),
        ],
      ),
    );
  }
}
