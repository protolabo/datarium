import 'package:flutter/material.dart';
import '../../../models/filter_option.dart';
import '../filter_screen.dart';

class Thermometer extends StatelessWidget {
  final double barHeight; // ignoré désormais, gardé pour compat
  final List<FilterOption> filters;
  final double totalConsumption; // en kWh

  const Thermometer({
    Key? key,
    required this.barHeight,
    required this.filters,
    required this.totalConsumption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hauteur totale du thermomètre
    const double H = 150;

    // Échelle simple: 0 kWh → 0%, 1 kWh → 100% (à ajuster si tu veux)
    final double percent = (totalConsumption / 1.0).clamp(0, 1);
    // Donne toujours au moins 6 px si >0 pour qu’on voie la couleur
    final double h = totalConsumption > 0 ? (percent * H).clamp(6, H) : 0;

    // Couleur selon seuils
    final _UsageLevel level = _level(totalConsumption);
    final Color fill = switch (level) {
      _UsageLevel.none => Colors.transparent,
      _UsageLevel.low => Colors.green,
      _UsageLevel.medium => Colors.orange,
      _UsageLevel.high => Colors.red,
    };

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
            height: H,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: h,
              width: 30,
              decoration: BoxDecoration(
                color: fill.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('${(totalConsumption * 1000).toStringAsFixed(1)} Wh'),
          const SizedBox(height: 4),
          if (level != _UsageLevel.none)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: fill.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: fill.withOpacity(0.4)),
              ),
              child: Text(
                switch (level) {
                  _UsageLevel.low => 'Utilisation faible',
                  _UsageLevel.medium => 'Utilisation modérée',
                  _UsageLevel.high => 'Utilisation élevée',
                  _ => '',
                },
                style: TextStyle(
                  color: fill,
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

enum _UsageLevel { none, low, medium, high }

_UsageLevel _level(double kwh) {
  if (kwh <= 0) return _UsageLevel.none;
  if (kwh < 0.3) return _UsageLevel.low;      // < 0.3 kWh
  if (kwh < 1.0) return _UsageLevel.medium;   // < 1 kWh
  return _UsageLevel.high;                    // ≥ 1 kWh
}
