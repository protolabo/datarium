/* import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool remindersEnabled = false;
  String language = "Français";
  String theme = "Light";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Paramètres",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              _buildSettingRow(
                icon: Icons.notifications,
                text: "Notifications",
                trailing: Switch(
                  activeColor: Colors.green,
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.add_to_photos,
                text: "Recevoir rappels",
                trailing: Switch(
                  activeColor: Colors.green,
                  value: remindersEnabled,
                  onChanged: (value) {
                    setState(() {
                      remindersEnabled = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.language,
                text: "Langue",
                trailing: Text(
                  "$language >",
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.nightlight_round,
                text: "Thème",
                trailing: Text(
                  theme,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        currentIndex: 0, // l'onglet paramètres sélectionné
        onTap: (index) {
          // à compléter si tu veux naviguer vers d'autres pages
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Temps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon Compte',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String text,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}

*/

import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'history_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paramètres',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.green[100],
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                trailing: Switch(value: true, onChanged: null),
              ),
              const ListTile(
                leading: Icon(Icons.add_to_photos),
                title: Text('Recevoir rappels'),
                trailing: Switch(value: false, onChanged: null),
              ),
              const ListTile(
                leading: Icon(Icons.language),
                title: Text('Langue'),
                trailing: Text('Français >'),
              ),
              const ListTile(
                leading: Icon(Icons.brightness_2),
                title: Text('Thème'),
                trailing: Text('Light'),
              ),
            ],
          ),
        ),
      ),

      // ✅ Nouvelle bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            // On y est déjà → SettingsScreen
          } else if (index == 1) {
            // Puce (ESP32) → ne fait rien pour le moment
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardScreen(filters: const []),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Datarium'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Historique',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ],
      ),
    );
  }
}
