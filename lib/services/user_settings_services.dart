import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsService with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en', 'US');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  UserSettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 2];
    _locale = Locale(prefs.getString('languageCode') ?? 'en', 'US');
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = themeMode;
    await prefs.setInt('themeMode', themeMode.index);
    notifyListeners();
  }

  Future<void> updateLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    _locale = locale;
    await prefs.setString('languageCode', locale.languageCode);
    notifyListeners();
  }
}
