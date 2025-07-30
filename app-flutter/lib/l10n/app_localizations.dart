/* import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);
  

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      'title': 'Datarium',
      'notifications': 'Notifications',
      'reminders': 'Receive reminders',
      'language': 'Language',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'profile': 'Profile',
      'history': 'History',
      'home': 'Home',
      'apply': 'Apply',
      'enter_date_manually': 'Enter date manually',
      'energy_consumption': 'Energy consumption',
      'daily': 'daily',
      'weekly': 'weekly',
      'monthly': 'monthly',
      'custom': 'custom',
    },
    'fr': {
      'title': 'Datarium',
      'notifications': 'Notifications',
      'reminders': 'Recevoir rappels',
      'language': 'Langue',
      'theme': 'Thème',
      'light': 'Clair',
      'dark': 'Sombre',
      'profile': 'Profil',
      'history': 'Historique',
      'home': 'Accueil',
      'apply': 'Appliquer',
      'enter_date_manually': 'Entrer manuellement une date',
      'energy_consumption': 'Consommation énergétique',
      'daily': 'journalière',
      'weekly': 'hebdomadaire',
      'monthly': 'mensuelle',
      'custom': 'personnalisée',
    },
  };

  String _translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key]!;
  }

  String get title => _translate('title');
  String get notifications => _translate('notifications');
  String get reminders => _translate('reminders');
  String get language => _translate('language');
  String get theme => _translate('theme');
  String get light => _translate('light');
  String get dark => _translate('dark');
  String get profile => _translate('profile');
  String get history => _translate('history');
  String get home => _translate('home');
  String get apply => _translate('apply');
  String get enterDateManually => _translate('enter_date_manually');
  String get energyConsumption => _translate('energy_consumption');
  String get daily => _translate('daily');
  String get weekly => _translate('weekly');
  String get monthly => _translate('monthly');
  String get custom => _translate('custom');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}


*/

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();
  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('fr', ''),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      'title': 'Datarium',
      'notifications': 'Notifications',
      'reminders': 'Receive reminders',
      'language': 'Language',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'profile': 'Profile',
      'history': 'History',
      'home': 'Home',
      'apply': 'Apply',
      'enter_date_manually': 'Enter date manually',
      'energy_consumption': 'Energy consumption',
      'daily': 'daily',
      'weekly': 'weekly',
      'monthly': 'monthly',
      'custom': 'custom',
    },
    'fr': {
      'title': 'Datarium',
      'notifications': 'Notifications',
      'reminders': 'Recevoir rappels',
      'language': 'Langue',
      'theme': 'Thème',
      'light': 'Clair',
      'dark': 'Sombre',
      'profile': 'Profil',
      'history': 'Historique',
      'home': 'Accueil',
      'apply': 'Appliquer',
      'enter_date_manually': 'Entrer manuellement une date',
      'energy_consumption': 'Consommation énergétique',
      'daily': 'journalière',
      'weekly': 'hebdomadaire',
      'monthly': 'mensuelle',
      'custom': 'personnalisée',
    },
  };

  String _translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key]!;
  }

  String get title => _translate('title');
  String get notifications => _translate('notifications');
  String get reminders => _translate('reminders');
  String get language => _translate('language');
  String get theme => _translate('theme');
  String get light => _translate('light');
  String get dark => _translate('dark');
  String get profile => _translate('profile');
  String get history => _translate('history');
  String get home => _translate('home');
  String get apply => _translate('apply');
  String get enterDateManually => _translate('enter_date_manually');
  String get energyConsumption => _translate('energy_consumption');
  String get daily => _translate('daily');
  String get weekly => _translate('weekly');
  String get monthly => _translate('monthly');
  String get custom => _translate('custom');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
