import 'package:flutter/material.dart';
import 'package:zippy/screens/accessibility_display_and_languages_settings_screen.dart';
import 'package:zippy/screens/notification_settings_screen.dart';
import 'package:zippy/screens/privacy_and_safety_settings_screen.dart';
import 'package:zippy/screens/security_and_account_access_settings_screen.dart';
import 'package:zippy/screens/your_account_settings_screen.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Your account'),
            subtitle: const Text('See information about your account, download an archive of your data or learn about your account deactivation options.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const YourAccountSettings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security and account access'),
            subtitle: const Text('Manage your account\'s security, and keep track of your account usage, including apps that you have connected to your account.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityAndAccountAccessSettings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy and safety'),
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
            title: const Text('Accessibility, display, and languages'),
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
