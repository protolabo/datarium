import 'package:flutter/material.dart';
import '../../../models/filter_option.dart';
import 'thermometer.dart';
import 'energy_tile.dart';
import 'recommendation_tile.dart';

class MainContent extends StatelessWidget {
  final List<FilterOption> filters;
  final Map<String, double> categoryConsumption;
  final int recommendationCount;
  final double barHeight;
  final double totalConsumption;

  const MainContent({
    Key? key,
    required this.filters,
    required this.categoryConsumption,
    required this.recommendationCount,
    required this.barHeight,
    required this.totalConsumption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build energy tiles
    final energyTiles = <Widget>[
      for (var f in filters)
        if (f.isSelected)
          EnergyTile(
            name: f.name,
            consumption: categoryConsumption[f.name] ?? 0,
          ),
    ];
    if (energyTiles.isEmpty) {
      energyTiles.add(
        const Text(
          "Aucun filtre sélectionné.",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Thermometer(
            barHeight: barHeight,
            filters: filters,
            totalConsumption: totalConsumption,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Requêtes énergivores',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...energyTiles,
                const SizedBox(height: 16),
                RecommendationTile(count: recommendationCount),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
