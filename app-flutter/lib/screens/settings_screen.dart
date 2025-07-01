import 'package:flutter/material.dart';

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
