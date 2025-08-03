/* import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DatariumApp());
}

class DatariumApp extends StatelessWidget {
  const DatariumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Datarium',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Arial'),
      home: const SplashScreen(),
    );
  }
}

*/

import 'package:datarium/screens/filters_provider.dart';
import 'package:datarium/screens/settings_provider.dart';
import 'package:datarium/screens/splash_screen.dart';
import 'package:datarium/widgets/BottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FiltersProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Datarium',
            theme: ThemeData(
              useMaterial3: true,
              brightness: settings.isDarkTheme ? Brightness.dark : Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              iconTheme: const IconThemeData(color: Colors.green),
            ),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: settings.locale,
            supportedLocales: [
              Locale('en'), // English
              Locale('fr'), // French
            ],
            home: const SplashScreen(), // Initial screen
          );
        },
      ),
    );
  }
}
