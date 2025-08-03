import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class DashboardHeader extends StatelessWidget {
  final double dataRate;
  final int duration;

  const DashboardHeader({Key? key, required this.dataRate, required this.duration})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.headerTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    'Streaming',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Crypto Ex…',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Débit : ${dataRate.toStringAsFixed(1)} oct/s',
                    style: const TextStyle(color: Colors.green),
                  ),
                  Text('Durée : ${duration}s', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
