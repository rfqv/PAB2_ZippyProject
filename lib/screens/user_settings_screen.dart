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
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Your account'),
            subtitle: Text('See information about your account, download an archive of your data or learn about your account deactivation options.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => YourAccountSettings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Security and account access'),
            subtitle: Text('Manage your account\'s security, and keep track of your account usage, including apps that you have connected to your account.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SecurityAndAccountAccessSettings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy and safety'),
            subtitle: Text('Manage what information you see and share on Zippy.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyAndSafetySettings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification'),
            subtitle: Text('Select the kinds of notification you get about your activities, interests and recommendations.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.accessibility),
            title: Text('Accessibility, display, and languages'),
            subtitle: Text('Manage how Zippy content is displayed to you.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AccessibilityDisplayAndLanguagesSettings()));
            },
          ),
        ],
      ),
    );
  }
}
