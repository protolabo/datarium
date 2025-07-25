import 'package:flutter/material.dart';
import 'constants.dart';

final ThemeData appTheme = ThemeData(
  // 1) Color scheme
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.danger,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),

  // 2) Typography
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.muted),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ),

  // 3) ElevatedButton theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
    ),
  ),

  // 4) InputDecoration theme
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.all(AppSpacing.md),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
  ),
);

// 5) Handy extension to access spacing off BuildContext
extension SpacingExt on BuildContext {
  double get xs => AppSpacing.xs;
  double get sm => AppSpacing.sm;
  double get md => AppSpacing.md;
  double get lg => AppSpacing.lg;
  double get xl => AppSpacing.xl;
}
