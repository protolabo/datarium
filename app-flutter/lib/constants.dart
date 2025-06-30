import 'package:flutter/material.dart';

/// Raw color values (best to use colors via Theme)
class AppColors {
  static const Color primary  = Color(0xFF0055FF);
  static const Color secondary = Color(0xFFFFA000);
  static const Color danger    = Color(0xFFE53935);
  static const Color success   = Color(0xFF43A047);
  static const Color muted     = Color(0xFF9E9E9E);
}

/// Standard spacing units (e.g. for padding & margin)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// Animation / transition durations
class AppDurations {
  static const Duration short  = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long   = Duration(milliseconds: 600);
}
