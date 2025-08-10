import 'package:flutter/material.dart';
import '../models/filter_option.dart';

enum Period { day, week, month, custom }

class FiltersProvider extends ChangeNotifier {
  // ---- Catégories disponibles partout dans l’app (ordre d’affichage) ----
  static const List<String> _allCategories = <String>[
    'Streaming',
    'Gaming',
    'AI/ LLM',
    'Unknown', // NEW
  ];

  // ---- État des filtres ----
  Period _selectedPeriod = Period.day;
  DateTimeRange? _customRange;

  // Par défaut on active toutes les catégories (y compris Unknown)
  List<String> _selectedCategories = List.of(_allCategories);

  // ---- Couleurs (courbes, légendes, chips…) ----
  static const Map<String, Color> _defaultColors = <String, Color>{
    'Streaming': Colors.blue,
    'Gaming': Colors.purple,
    'AI/ LLM': Colors.amber,
    'Unknown': Colors.grey, // NEW
  };

  // Palette mutable actuelle
  final Map<String, Color> _appColors = Map<String, Color>.from(_defaultColors);

  // ---- Getters publics ----
  Period get selectedPeriod => _selectedPeriod;
  DateTimeRange? get customRange => _customRange;

  /// Liste des catégories cochées (copie immuable pour éviter les modifs externes)
  List<String> get selectedCategories => List.unmodifiable(_selectedCategories);

  /// Couleurs (copie immuable)
  Map<String, Color> get appColors => Map.unmodifiable(_appColors);

  /// Liste complète des catégories (ordre d’affichage)
  List<String> get allCategories => List.of(_allCategories);

  // ---- Actions période ----
  void setPeriod(Period period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void setCustomRange(DateTimeRange range) {
    _customRange = range;
    notifyListeners();
  }

  // ---- Sélection catégories ----
  void toggleCategory(String category, bool isSelected) {
    if (isSelected) {
      if (!_selectedCategories.contains(category)) {
        _selectedCategories.add(category);
      }
    } else {
      _selectedCategories.remove(category);
    }
    notifyListeners();
  }

  void resetFilters() {
    _selectedPeriod = Period.day;
    _customRange = null;
    _selectedCategories = List.of(_allCategories);
    _appColors
      ..clear()
      ..addAll(_defaultColors);
    notifyListeners();
  }

  // ---- Conversions pour les écrans qui utilisent FilterOption ----
  List<FilterOption> asFilterOptions() {
    return _allCategories
        .map((name) => FilterOption(
              name: name,
              isSelected: _selectedCategories.contains(name),
            ))
        .toList();
  }

  void updateFromFilterOptions(List<FilterOption> options) {
    _selectedCategories =
        options.where((f) => f.isSelected).map((f) => f.name).toList();
    notifyListeners();
  }

  /// Réinitialise la palette puis applique la sélection passée.
  void updateAppColorsFromFilterOptions(List<FilterOption> options) {
    updateFromFilterOptions(options);
    _appColors
      ..clear()
      ..addAll(_defaultColors);
    notifyListeners();
  }

  /// Alias pratique (compat).
  void setFromFilterOptions(List<FilterOption> filters) =>
      updateFromFilterOptions(filters);

  /// Couleur d’une catégorie donnée.
  Color colorFor(String category) => _appColors[category] ?? Colors.grey;
}
