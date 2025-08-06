// lib/screens/main_navigation.dart
import 'package:datarium/screens/dashboard/dashboard_screen.dart';
import 'package:datarium/screens/history/history_screen.dart';
import 'package:datarium/screens/profil/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  /// On ajoute ici le networkId reçu depuis le SplashScreen
  final String networkId;

  const MainScaffold({
    Key? key,
    required this.networkId,
  }) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    // Comme on est dans build, on a accès à widget.networkId
    final screens = <Widget>[
      // On passe le networkId à DashboardScreen
      DashboardScreen(networkId: widget.networkId),
      const ProfileScreen(),
      const Center(child: Text('Datarium')),
      const HistoryScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Datarium'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Historique',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
