import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/filter_option.dart';
import '../../services/data_service.dart';
import '../../models/data_stats.dart';

class DashboardViewModel extends ChangeNotifier {
  final DataService _dataService;
  Timer? _timer;

  String? _networkId;

  double dataRate = 0;
  int duration = 0;
  double recentData = 0;

  Map<String, double> categoryConsumption = {
    "Streaming": 0,
    "Gaming": 0,
    "AI/LLM": 0,
  };

  /// Nombre de catégories dont la conso est > 0
  int recommendationCount = 0;

  DashboardViewModel(this._dataService);

  void init(String networkId) {
    _networkId = networkId;
    _fetchAndUpdateData();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _fetchAndUpdateData(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dataService.dispose();
    super.dispose();
  }

  Future<void> _fetchAndUpdateData() async {
    if (_networkId == null) return;

    try {
      final stats = await _dataService.fetchDataStats(_networkId!);
      dataRate = stats.dataRate;
      duration = stats.duration;
      recentData = stats.recentData;
      categoryConsumption = {
        "Streaming": stats.streamingConsumption,
        "Gaming":    stats.gamingConsumption,
        "AI/LLM":    stats.aiConsumption,
      };

      // recalcul auto du nombre de recommandations
      recommendationCount = categoryConsumption.values
          .where((v) => v > 0)
          .length;

      notifyListeners();
    } catch (e) {
      debugPrint("Erreur lors du chargement des données : $e");
    }
  }

  double calculateTotalConsumption(List<FilterOption> filters) {
    return filters
        .where((f) => f.isSelected)
        .map((f) => categoryConsumption[f.name] ?? 0)
        .fold(0.0, (a, b) => a + b);
  }
}
