import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _notificationsEnabled = false;
  bool _remindersEnabled = false;
  bool _isDarkTheme = false;
  Locale _locale = const Locale('fr');

  bool get notificationsEnabled => _notificationsEnabled;
  bool get remindersEnabled => _remindersEnabled;
  bool get isDarkTheme => _isDarkTheme;
  Locale get locale => _locale;

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void toggleReminders(bool value) {
    _remindersEnabled = value;
    notifyListeners();
  }

  void toggleTheme(bool value) {
    _isDarkTheme = value;
    notifyListeners();
  }

  void changeLanguage(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
