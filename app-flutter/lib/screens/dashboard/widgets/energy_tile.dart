import 'package:flutter/material.dart';

class EnergyTile extends StatelessWidget {
  final String name;
  final double consumption; // kWh

  const EnergyTile({
    Key? key,
    required this.name,
    required this.consumption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badge = _usageBadge(consumption); // null si 0 => rien à afficher

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
              if (badge != null) badge, // <= n’affiche rien si 0
            ],
          ),
        ],
      ),
    );
  }

  /// Retourne un label coloré selon le niveau, ou null si conso = 0
  Widget? _usageBadge(double kwh) {
    if (kwh <= 0) return null;

    late final Color color;
    late final String text;

    if (kwh < 0.2) {
      color = Colors.green;
      text = 'Utilisation faible';
    } else if (kwh < 1.0) {
      color = Colors.orange;
      text = 'Utilisation modérée';
    } else {
      color = Colors.red;
      text = 'Utilisation élevée';
    }

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }
}
