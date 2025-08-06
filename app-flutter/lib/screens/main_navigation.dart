/*

// lib/screens/main_navigation.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard/dashboard_screen.dart';
import 'esp32/esp32_config_screen.dart';
import 'history/history_screen.dart';
import 'profil/profile_screen.dart';
import 'filters_provider.dart';

class MainNavigation extends StatefulWidget {
   /// Reçoit le networkId sélectionné au splash screen
  final String networkId;

  const MainNavigation({
    Key? key,
    required this.networkId,
  }) : super(key: key);

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
*/

import 'package:flutter/material.dart';
import 'package:datarium/screens/dashboard/dashboard_screen.dart';
import 'package:datarium/screens/esp32/esp32_config_screen.dart';
import 'package:datarium/screens/history/history_screen.dart';
import 'package:datarium/screens/profil/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  /// Reçoit le networkId sélectionné au SplashScreen
  final String networkId;

  const MainNavigation({Key? key, required this.networkId}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    DashboardScreen(networkId: widget.networkId),
    Esp32ConfigScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.memory),   label: 'ESP32'),
          BottomNavigationBarItem(icon: Icon(Icons.history),  label: 'Historique'),
          BottomNavigationBarItem(icon: Icon(Icons.person),   label: 'Profil'),
        ],
      ),
    );
  }
}
