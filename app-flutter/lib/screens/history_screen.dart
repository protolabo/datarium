import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyHistory = [
      {"time": "2025-06-27 17:22", "app": "Mining", "kwh": "2.3"},
      {"time": "2025-06-27 17:15", "app": "Streaming", "kwh": "0.8"},
      {"time": "2025-06-27 16:59", "app": "Gaming", "kwh": "1.0"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: dummyHistory.length,
        itemBuilder: (context, index) {
          final item = dummyHistory[index];
          return ListTile(
            leading: const Icon(Icons.bolt, color: Colors.green),
            title: Text("${item["app"]} - ${item["kwh"]} kWh"),
            subtitle: Text(item["time"]!),
          );
        },
      ),
    );
  }
}
