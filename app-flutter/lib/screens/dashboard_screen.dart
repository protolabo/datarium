/* 

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filter_option.dart';
import 'filter_screen.dart';
import 'filters_provider.dart';
import 'recommendations_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  

  double dataRate = 0;
  int duration = 0;
  double recentData = 0;

  int recommendationCount = 3;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  Map<String, double> categoryConsumption = {
    "Streaming": 0,
    "Gaming": 0,
    "AI/ LLM": 0,
  };

  @override
  void initState() {
    super.initState();
    final filtersProvider = Provider.of<FiltersProvider>(
      context,
      listen: false,
    );
    activeFilters = filtersProvider.asFilterOptions();

    _generateRandomData();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        _generateRandomData();
        duration += 2;
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  double get totalConsumption {
    return activeFilters
        .where((f) => f.isSelected)
        .map((f) => categoryConsumption[f.name] ?? 0)
        .fold(0.0, (a, b) => a + b);
  }

  void _generateRandomData() {
    final rng = Random();
    categoryConsumption = {
      "Streaming": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "Gaming": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "AI/ LLM": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
    };
    dataRate = rng.nextDouble() * 500 + 100;
    recentData = rng.nextDouble() * 1500;
  }

  Future<void> openFilterScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(initialFilters: activeFilters),
      ),
    );
    if (result != null && result is List<FilterOption>) {
      final filtersProvider = Provider.of<FiltersProvider>(
        context,
        listen: false,
      );
      setState(() {
        activeFilters = filtersProvider.asFilterOptions();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final barHeight =
        totalConsumption > 20 ? 150.0 : (totalConsumption / 20) * 150;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Activité en direct',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () {
              setState(() {
                recommendationCount++;
                _controller.forward().then((_) => _controller.reverse());
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildConsumptionBar(),
            _buildMainContent(barHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text(
                'Streaming',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Crypto Ex...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
              Text(
                'Durée : ${duration}s',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionBar() {
    return Container(
      width: double.infinity,
      color: Colors.green[300],
      padding: const EdgeInsets.all(8),
      child: Text(
        'Dernières 5 min : ${recentData.toStringAsFixed(1)} oct/s',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMainContent(double barHeight) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThermometer(barHeight),
          const SizedBox(width: 16),
          Expanded(child: _buildRightColumn()),
        ],
      ),
    );
  }

  Widget _buildThermometer(double barHeight) {
    return Column(
      children: [
        GestureDetector(
          onTap: openFilterScreen,
          child: Column(
            children: [
              const Icon(Icons.filter_list, color: Colors.black),
              const SizedBox(height: 16),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: barHeight,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${totalConsumption.toStringAsFixed(1)} kWh',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Utilisation élevée',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    final energyTiles = _buildEnergyTiles();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Requêtes énergivores',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...energyTiles,
        const SizedBox(height: 16),
        _buildRecommendationTile(),
      ],
    );
  }

  Widget _buildRecommendationTile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecommendationsScreen()),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Recommandations',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (recommendationCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      '$recommendationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildEnergyTiles() {
    final tiles = <Widget>[];

    for (var f in activeFilters) {
      if (f.isSelected) {
        tiles.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  f.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${categoryConsumption[f.name]?.toStringAsFixed(2) ?? "0.00"} kWh',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Utilisation élevée',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }

    if (tiles.isEmpty) {
      tiles.add(
        const Text(
          "Aucun filtre sélectionné.",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return tiles;
  }
}


*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filter_option.dart';
import 'filter_screen.dart';
import 'filters_provider.dart';
import 'recommendations_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late Timer timer;

  double dataRate = 0;
  int duration = 0;
  double recentData = 0;

  int recommendationCount = 3;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  Map<String, double> categoryConsumption = {
    "Streaming": 0,
    "Gaming": 0,
    "AI/ LLM": 0,
  };

  @override
  void initState() {
    super.initState();

    _generateRandomData();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        _generateRandomData();
        duration += 2;
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  double calculateTotalConsumption(List<FilterOption> filters) {
    return filters
        .where((f) => f.isSelected)
        .map((f) => categoryConsumption[f.name] ?? 0)
        .fold(0.0, (a, b) => a + b);
  }

  void _generateRandomData() {
    final rng = Random();
    categoryConsumption = {
      "Streaming": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "Gaming": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "AI/ LLM": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
    };
    dataRate = rng.nextDouble() * 500 + 100;
    recentData = rng.nextDouble() * 1500;
  }

  Future<void> openFilterScreen(List<FilterOption> currentFilters) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(initialFilters: currentFilters),
      ),
    );
    setState(() {}); // Rebuild to reflect new filters
  }

  @override
  Widget build(BuildContext context) {
    final filtersProvider = Provider.of<FiltersProvider>(context);
    final activeFilters = filtersProvider.asFilterOptions();
    final totalConsumption = calculateTotalConsumption(activeFilters);
    final barHeight =
        totalConsumption > 20 ? 150.0 : (totalConsumption / 20) * 150;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Activité en direct',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () {
              setState(() {
                recommendationCount++;
                _controller.forward().then((_) => _controller.reverse());
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildConsumptionBar(),
            _buildMainContent(barHeight, activeFilters, totalConsumption),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text(
                'Streaming',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Crypto Ex...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
              Text(
                'Durée : ${duration}s',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionBar() {
    return Container(
      width: double.infinity,
      color: Colors.green[300],
      padding: const EdgeInsets.all(8),
      child: Text(
        'Dernières 5 min : ${recentData.toStringAsFixed(1)} oct/s',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMainContent(
    double barHeight,
    List<FilterOption> filters,
    double totalConsumption,
  ) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThermometer(barHeight, filters, totalConsumption),
          const SizedBox(width: 16),
          Expanded(child: _buildRightColumn(filters)),
        ],
      ),
    );
  }

  Widget _buildThermometer(
    double barHeight,
    List<FilterOption> filters,
    double totalConsumption,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => openFilterScreen(filters),
          child: Column(
            children: [
              const Icon(Icons.filter_list, color: Colors.black),
              const SizedBox(height: 16),
              Container(
                height: 150,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: barHeight,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${totalConsumption.toStringAsFixed(1)} kWh',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Utilisation élevée',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(List<FilterOption> filters) {
    final energyTiles = _buildEnergyTiles(filters);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Requêtes énergivores',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...energyTiles,
        const SizedBox(height: 16),
        _buildRecommendationTile(),
      ],
    );
  }

  Widget _buildRecommendationTile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecommendationsScreen()),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Recommandations',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (recommendationCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      '$recommendationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildEnergyTiles(List<FilterOption> filters) {
    final tiles = <Widget>[];

    for (var f in filters) {
      if (f.isSelected) {
        tiles.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  f.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${categoryConsumption[f.name]?.toStringAsFixed(2) ?? "0.00"} kWh',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Utilisation élevée',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }

    if (tiles.isEmpty) {
      tiles.add(
        const Text(
          "Aucun filtre sélectionné.",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return tiles;
  }
}
