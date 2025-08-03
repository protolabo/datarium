// lib/screens/main_navigation.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard/dashboard_screen.dart';
import 'esp32/esp32_config_screen.dart';
import 'history/history_screen.dart';
import 'profil/profile_screen.dart';
import 'filters_provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // 3 = Dashboard par défaut

  @override
  Widget build(BuildContext context) {
    final filtersProvider = Provider.of<FiltersProvider>(context);

    final screens = [
      const DashboardScreen(),
      const HistoryScreen(),
      const Esp32ConfigScreen(), // À remplacer par l'écran Datarium/ESP32 si besoin
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Historique'),
          BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Datarium'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
