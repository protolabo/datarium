import 'package:flutter/material.dart';
import '../models/filter_option.dart';

enum Period { day, week, month, custom }

class FiltersProvider extends ChangeNotifier {
  Period _selectedPeriod = Period.day;
  DateTimeRange? _customRange;
  List<String> _selectedCategories = ["Streaming", "Gaming", "AI/ LLM"];

  // Private app colors map
  final Map<String, Color> _appColors = {
    "Streaming": Colors.blue,
    "Gaming": Colors.purple,
    "AI/ LLM": Colors.amber,
  };

  // Private default colors map
  final Map<String, Color> _defaultColors = {
    "Streaming": Colors.blue,
    "Gaming": Colors.purple,
    "AI/ LLM": Colors.amber,
  };

  Period get selectedPeriod => _selectedPeriod;
  DateTimeRange? get customRange => _customRange;
  List<String> get selectedCategories => _selectedCategories;

  Map<String, Color> get appColors => _appColors;

  get filters => null;

  void setPeriod(Period period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void setCustomRange(DateTimeRange range) {
    _customRange = range;
    notifyListeners();
  }

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
    _selectedCategories = ["Streaming", "Gaming", "AI/ LLM"];
    notifyListeners();
  }

  List<FilterOption> asFilterOptions() {
    return ["Streaming", "Gaming", "AI/ LLM"]
        .map(
          (name) => FilterOption(
            name: name,
            isSelected: _selectedCategories.contains(name),
          ),
        )
        .toList();
  }

  void updateFromFilterOptions(List<FilterOption> options) {
    _selectedCategories =
        options.where((f) => f.isSelected).map((f) => f.name).toList();
    notifyListeners();
  }

  void updateAppColorsFromFilterOptions(List<FilterOption> options) {
    _selectedCategories =
        options.where((f) => f.isSelected).map((f) => f.name).toList();

    for (var app in _appColors.keys) {
      _appColors[app] = _defaultColors[app]!;
    }

    notifyListeners();
  }

  void setFromFilterOptions(List<FilterOption> filters) {
    _selectedCategories =
        filters.where((f) => f.isSelected).map((f) => f.name).toList();
    notifyListeners();
  }
}
