import 'package:flutter/material.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Recommendations"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            "Schedule Mining Hours",
            "Run mining during off-peak electricity hours.",
            Colors.orange,
          ),
          _buildCard(
            context,
            "Enable Power Saving Mode",
            "Activate system-wide energy efficient settings.",
            Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            "Quick Tips",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          const Text(
            "• Close unused browser tabs to reduce background processing.",
          ),
          const Text("• Use dark mode to save display energy on OLED screens."),
          const Text("• Schedule heavy downloads during off-peak hours."),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String description,
    Color color,
  ) {
    return Card(
      color: color.withOpacity(0.2),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward, color: color),
        onTap: () {
          // Placeholder for deeper navigation
        },
      ),
    );
  }
}
