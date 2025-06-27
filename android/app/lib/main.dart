import 'package:flutter/material.dart';
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
