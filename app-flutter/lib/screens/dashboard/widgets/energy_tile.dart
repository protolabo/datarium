import 'package:flutter/material.dart';

class EnergyTile extends StatelessWidget {
  final String name;
  final double consumption;

  const EnergyTile({
    Key? key,
    required this.name,
    required this.consumption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${consumption.toStringAsFixed(2)} kWh',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Utilisation élevée',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
