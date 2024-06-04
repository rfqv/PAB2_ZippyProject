import 'package:flutter/material.dart';
import 'package:zippy/firebase_options.dart';
import 'package:zippy/navigator/app_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:zippy/screens/sign_in_screen.dart';
import 'package:zippy/screens/sign_out_screen.dart';
import 'package:zippy/screens/your_account_settings_screen.dart';
import 'package:zippy/screens/accessibility_display_and_languages_settings_screen.dart';
import 'package:zippy/services/user_settings_services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserSettingsService(),
      child: Consumer<UserSettingsService>(
        builder: (context, settings, child) {
          bool isDarkMode = settings.themeMode == ThemeMode.dark || (settings.themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Zippy',
            theme: ThemeData(
              primaryColor: const Color(0xFF7DABCF),
              scaffoldBackgroundColor: const Color(0xFFBAD6EB),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: const Color(0xFF7DABCF),
                selectedItemColor: Colors.black,
                unselectedItemColor: const Color(0xFFF7F7F7),
              ),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: settings.themeMode,
            locale: settings.locale,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('id', 'ID'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const MyBottomNavbar();
                } else {
                  return const SignInScreen();
                }
              },
            ),
            routes: {
              '/sign-in': (context) => const SignInScreen(),
              '/sign-out': (context) => const SignOutScreen(),
              '/your-account-settings': (context) => const YourAccountSettings(),
              '/accessibility-display-and-languages-settings': (context) => const AccessibilityDisplayAndLanguagesSettings(),
            },
          );
        },
      ),
    );
  }
}
