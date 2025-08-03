
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Paramètres",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                  value: settings.notificationsEnabled,
                  onChanged: settings.toggleNotifications,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.add_to_photos,
                text: "Recevoir rappels",
                trailing: Switch(
                  activeColor: Colors.green,
                  value: settings.remindersEnabled,
                  onChanged: settings.toggleReminders,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.language,
                text: "Langue",
                trailing: DropdownButton<Locale>(
                  value: settings.locale,
                  underline: const SizedBox(),
                  onChanged: (locale) {
                    if (locale != null) {
                      settings.changeLanguage(locale);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('fr'),
                      child: Text("Français"),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text("English"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.nightlight_round,
                text: "Thème",
                trailing: Switch(
                  activeColor: Colors.green,
                  value: settings.isDarkTheme,
                  onChanged: settings.toggleTheme,
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
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            // Tu es déjà ici
          } else if (index == 1) {
            // ESP32 → rien à faire
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Datarium'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Historique'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String text,
    required Widget trailing,
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
        trailing,
      ],
    );
  }
}

*/
// lib/screens/profile_screen.dart


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Paramètres",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                  value: settings.notificationsEnabled,
                  onChanged: settings.toggleNotifications,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.add_to_photos,
                text: "Recevoir rappels",
                trailing: Switch(
                  activeColor: Colors.green,
                  value: settings.remindersEnabled,
                  onChanged: settings.toggleReminders,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.language,
                text: "Langue",
                trailing: DropdownButton<Locale>(
                  value: settings.locale,
                  underline: const SizedBox(),
                  onChanged: (locale) {
                    if (locale != null) {
                      settings.changeLanguage(locale);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('fr'),
                      child: Text("Français"),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text("English"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.nightlight_round,
                text: "Thème",
                trailing: Switch(
                  activeColor: Colors.green,
                  value: settings.isDarkTheme,
                  onChanged: settings.toggleTheme,
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
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            // Tu es déjà ici
          } else if (index == 1) {
            // ESP32 → rien à faire
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Datarium'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Historique'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String text,
    required Widget trailing,
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
        trailing,
      ],
    );
  }
}

*/
// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Paramètres",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                  value: settings.notificationsEnabled,
                  onChanged: settings.toggleNotifications,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.add_to_photos,
                text: "Recevoir rappels",
                trailing: Switch(
                  activeColor: Colors.green,
                  value: settings.remindersEnabled,
                  onChanged: settings.toggleReminders,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.language,
                text: "Langue",
                trailing: DropdownButton<Locale>(
                  value: settings.locale,
                  underline: const SizedBox(),
                  onChanged: (locale) {
                    if (locale != null) {
                      settings.changeLanguage(locale);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('fr'),
                      child: Text("Français"),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text("English"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingRow(
                icon: Icons.nightlight_round,
                text: "Thème",
                trailing: Switch(
                  activeColor: Colors.green,
                  value: settings.isDarkTheme,
                  onChanged: settings.toggleTheme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String text,
    required Widget trailing,
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
        trailing,
      ],
    );
  }
}
