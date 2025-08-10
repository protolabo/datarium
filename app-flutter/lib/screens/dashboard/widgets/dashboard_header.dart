// lib/screens/dashboard/widgets/dashboard_header.dart
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class DashboardHeader extends StatelessWidget {
  /// Débit en octets/s
  final double dataRate;

  /// Durée (secondes)
  final int duration;

  /// Octets cumulés sur la dernière fenêtre (ex. 5 min)
  final double recentBytes;

  const DashboardHeader({
    Key? key,
    required this.dataRate,
    required this.duration,
    required this.recentBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            // Si tu as loc.headerTitle généré, décommente la ligne suivante
            // text: loc.headerTitle,
            'Activité en direct',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        // Bande débit / durée
        Container(
          width: double.infinity,
          color: Colors.green[100],
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // i18n: "Débit : {rate} oct/s"
                loc.labelThroughput(double.parse(dataRate.toStringAsFixed(1))),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                // i18n: "Durée : {seconds}s"
                loc.labelDuration(duration),
              ),
            ],
          ),
        ),

        // Bande "Dernières 5 min : N oct"  (bien en octets, pas oct/s)
        Container(
          width: double.infinity,
          color: Colors.green[600],
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            // i18n: "Dernières 5 min : {recent} oct"
            loc.recentData(recentBytes.round()),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
