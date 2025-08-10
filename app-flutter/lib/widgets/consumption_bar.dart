import 'package:flutter/material.dart';

class ConsumptionBar extends StatelessWidget {
  /// Volume d’octets sur la dernière fenêtre (ex. 5 min)
  final double recentData;

  const ConsumptionBar({super.key, required this.recentData});

  @override
  Widget build(BuildContext context) {
    debugPrint('✅ main_content from lib/widgets loaded');
    final double bytes =
        (recentData.isFinite && recentData > 0) ? recentData : 0.0;

    final _UsageLevel level = _levelFromBytes(bytes);
    final bool showChip = level != _UsageLevel.none;

    final String label = switch (level) {
      _UsageLevel.low => 'Utilisation faible',
      _UsageLevel.medium => 'Utilisation modérée',
      _UsageLevel.high => 'Utilisation élevée',
      _ => '',
    };

    final Color color = switch (level) {
      _UsageLevel.low => Colors.green,
      _UsageLevel.medium => Colors.orange,
      _UsageLevel.high => Colors.red,
      _ => Colors.transparent,
    };

    final double percent = _percentFromBytes(bytes); // 0.0 → 1.0

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Jauge verticale
          Column(
            children: [
              Container(
                width: 24,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: percent,
                  widthFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(showChip ? 0.85 : 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(_formatBytes(bytes)),
            ],
          ),
          const SizedBox(width: 12),

          // Badge de niveau (seulement si > 0)
          if (showChip)
            Chip(
              label: Text(label),
              backgroundColor: color.withOpacity(0.15),
              labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
              side: BorderSide(color: color.withOpacity(0.4)),
            ),
        ],
      ),
    );
  }
}

enum _UsageLevel { none, low, medium, high }

_UsageLevel _levelFromBytes(double bytes) {
  if (bytes <= 0) return _UsageLevel.none;
  final double kb = bytes / 1024.0;
  if (kb < 500) return _UsageLevel.low; // < 0.5 MB
  if (kb < 5000) return _UsageLevel.medium; // < 5 MB
  return _UsageLevel.high;
}

double _percentFromBytes(double bytes) {
  // 0 → 0%, 5 MB → 100%, au-delà on sature à 100%
  const double fiveMb = 5 * 1024 * 1024;
  if (bytes <= 0) return 0.0;
  return (bytes / fiveMb).clamp(0.0, 1.0);
}

String _formatBytes(double bytes) {
  if (bytes < 1024) return '${bytes.toStringAsFixed(0)} B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} kB';
  }
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
