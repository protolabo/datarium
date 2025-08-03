import 'package:flutter/material.dart';

class ConsumptionBar extends StatelessWidget {
  final double recentData;

  const ConsumptionBar({Key? key, required this.recentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.green[300],
      padding: const EdgeInsets.all(8),
      child: Text(
        'Dernières 5 min : ${recentData.toStringAsFixed(1)} oct/s',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
