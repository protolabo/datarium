import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  final List<String> filters; // non utilisé ici mais conservé pour compat
  final Map<String, double> categoryConsumption; // kWh
  final int recommendationCount;
  final double barHeight;
  final double totalConsumption;

  const MainContent({
    super.key,
    required this.filters,
    required this.categoryConsumption,
    required this.recommendationCount,
    required this.barHeight,
    required this.totalConsumption,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final e in categoryConsumption.entries)
            Card(
              elevation: 0,
              color: Colors.grey[200],
              child: ListTile(
                title: Text(e.key),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_formatEnergy(e.value),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    _usageBadge(e.value),
                  ],
                ),
              ),
            ),
          Card(
            color: Colors.green[100],
            child: ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.green),
              title: const Text('Recommandations'),
              trailing: Text(
                '$recommendationCount',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Même logique que le thermomètre : Wh si < 0.01 kWh
  String _formatEnergy(double kwh) {
    if (kwh < 0.01) return '${(kwh * 1000).toStringAsFixed(1)} Wh';
    if (kwh < 1) return '${kwh.toStringAsFixed(3)} kWh';
    return '${kwh.toStringAsFixed(2)} kWh';
  }

  Widget _usageBadge(double kwh) {
    if (kwh <= 0) return const SizedBox.shrink();
    final wh = kwh * 1000.0;
    if (wh < 10) {
      return Chip(
        label: const Text('Utilisation faible'),
        backgroundColor: Colors.green.withOpacity(0.12),
        labelStyle: const TextStyle(color: Colors.green),
        side: BorderSide(color: Colors.green.withOpacity(0.4)),
      );
    } else if (wh < 200) {
      return Chip(
        label: const Text('Utilisation modérée'),
        backgroundColor: Colors.orange.withOpacity(0.12),
        labelStyle: const TextStyle(color: Colors.orange),
        side: BorderSide(color: Colors.orange.withOpacity(0.4)),
      );
    } else {
      return Chip(
        label: const Text('Utilisation élevée'),
        backgroundColor: Colors.red.withOpacity(0.12),
        labelStyle: const TextStyle(color: Colors.red),
        side: BorderSide(color: Colors.red.withOpacity(0.4)),
      );
    }
  }
}
