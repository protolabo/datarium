import 'package:flutter/material.dart';
import '../../../models/filter_option.dart';
import '../filter_screen.dart';

class Thermometer extends StatelessWidget {
  final double barHeight;
  final List<FilterOption> filters;
  final double totalConsumption;

  const Thermometer({
    Key? key,
    required this.barHeight,
    required this.filters,
    required this.totalConsumption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FilterScreen(initialFilters: filters),
          ),
        );
      },
      child: Column(
        children: [
          const Icon(Icons.filter_list, color: Colors.black),
          const SizedBox(height: 16),
          Container(
            height: 150,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: barHeight,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${totalConsumption.toStringAsFixed(1)} kWh',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Utilisation élevée',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
