import 'package:flutter/material.dart';
import 'package:zippy/screens/settings/accessibility_display_and_languages_settings_screen.dart';
import 'package:zippy/screens/settings/notification_settings_screen.dart';
import 'package:zippy/screens/settings/privacy_and_safety_settings_screen.dart';
import 'package:zippy/screens/settings/security_and_account_access_settings_screen.dart';
import 'package:zippy/screens/settings/your_account_settings_screen.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Your Account'),
            subtitle: const Text('See information about your account, download an archive of your data or learn about your account deactivation options.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const YourAccountSettings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security and Account Access'),
            subtitle: const Text('Manage your account\'s security, and keep track of your account usage, including apps that you have connected to your account.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityAndAccountAccessSettings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy and Safety'),
            subtitle: const Text('Manage what information you see and share on Zippy.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyAndSafetySettings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification'),
            subtitle: const Text('Select the kinds of notification you get about your activities, interests and recommendations.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.accessibility),
            title: const Text('Accessibility, Display, and Languages'),
            subtitle: const Text('Manage how Zippy content is displayed to you.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AccessibilityDisplayAndLanguagesSettings()));
            },
          ),
        ],
      ),
    );
  }
}
