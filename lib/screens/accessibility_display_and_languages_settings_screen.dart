import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippy/services/user_settings_services.dart';

class AccessibilityDisplayAndLanguagesSettings extends StatefulWidget {
  const AccessibilityDisplayAndLanguagesSettings({super.key});

  @override
  _AccessibilityDisplayAndLanguagesSettingsState createState() => _AccessibilityDisplayAndLanguagesSettingsState();
}

class _AccessibilityDisplayAndLanguagesSettingsState extends State<AccessibilityDisplayAndLanguagesSettings> {
  late ThemeMode _themeMode;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<UserSettingsService>(context, listen: false);
    _themeMode = settings.themeMode;
    _locale = settings.locale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility, Display, and Languages'),
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
            title: Text('English'),
            leading: Radio(
              value: Locale('en', 'US'),
              groupValue: _locale,
              onChanged: (Locale? value) {
                setState(() {
                  _locale = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Bahasa Indonesia'),
            leading: Radio(
              value: Locale('id', 'ID'),
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
              final settings = Provider.of<UserSettingsService>(context, listen: false);
              settings.updateThemeMode(_themeMode);
              settings.updateLocale(_locale);
            },
            child: Text('Apply & Save'),
          ),
        ],
      ),
    );
  }
}
