import 'package:flutter/material.dart';
import 'package:zippy/screens/sign_in/sign_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:zippy/services/user_settings_services.dart';
import 'dart:async';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _navigateToSignIn();
  }

  _navigateToSignIn() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettingsService>(
      builder: (context, settings, child) {
        bool isDarkMode = settings.themeMode == ThemeMode.dark || (settings.themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);
        return Scaffold(
          body: Container(
            color: isDarkMode ? const Color(0xFF121212) : const Color(0xFFBAD6EB),
            child: Center(
              child: Image.asset(
                isDarkMode ? 'assets/logo/zippynotulisan.png' : 'assets/logo/zippyadatulisan.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
