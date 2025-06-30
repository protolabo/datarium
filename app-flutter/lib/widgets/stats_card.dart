import 'package:flutter/material.dart';
import '../models/data_stats.dart';
import '../constants.dart';
import '../theme.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const StatsCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.color, // override card color if you like
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: color ?? theme.colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(value, style: theme.textTheme.headlineMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
