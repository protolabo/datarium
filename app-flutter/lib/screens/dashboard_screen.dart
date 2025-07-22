/*



import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'filter_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import '../models/filter_option.dart';

class DashboardScreen extends StatefulWidget {
  final List<FilterOption> filters;

  const DashboardScreen({super.key, required this.filters});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer timer;

  double dataRate = 0;
  int duration = 0;
  double recentData = 0;

  Map<String, double> categoryConsumption = {
    "Mining": 0,
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
  }

  void _generateRandomData() {
    var rng = Random();

    categoryConsumption = {
      "Mining": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "Streaming": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "Gaming": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "AI/ LLM": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
    };

    dataRate = rng.nextDouble() * 500 + 100;
    recentData = rng.nextDouble() * 1500;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  double get totalConsumption =>
      categoryConsumption.values.fold(0, (a, b) => a + b);

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bandeau en-tête
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Mining',
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
            ),

            Container(
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
            ),

            const SizedBox(height: 16),

            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thermomètre vertical
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => FilterScreen(
                                    initialFilters: widget.filters,
                                  ),
                            ),
                          );
                          if (result != null && result is List<FilterOption>) {
                            setState(() {
                              widget.filters.setAll(
                                0,
                                result.map(
                                  (e) => FilterOption(
                                    name: e.name,
                                    isSelected: e.isSelected,
                                  ),
                                ),
                              );
                            });
                          }
                        },
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
                                  height: (totalConsumption / 20) * 150,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
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
                  ),

                  const SizedBox(width: 16),

                  // Requêtes énergivores
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Requêtes énergivores',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ..._buildEnergyTiles(),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            // pas modifié ici car RecommendationsScreen existe déjà
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: const [
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom navigation bar corrigée
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          } else if (index == 1) {
            // Puce → ne fait rien
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            );
          } else if (index == 3) {
            // Home → dashboard, on y est déjà
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Datarium'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Historique',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ],
      ),
    );
  }

  List<Widget> _buildEnergyTiles() {
    return categoryConsumption.entries.map((e) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${e.value.toStringAsFixed(2)} kWh',
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
      );
    }).toList();
  }
}


*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'filter_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'recommendations_screen.dart';
import '../models/filter_option.dart';

class DashboardScreen extends StatefulWidget {
  final List<FilterOption> filters;

  const DashboardScreen({super.key, required this.filters});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late Timer timer;

  double dataRate = 0;
  int duration = 0;
  double recentData = 0;

  late List<FilterOption> activeFilters;

  int recommendationCount = 3;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  Map<String, double> categoryConsumption = {
    "Mining": 0,
    "Streaming": 0,
    "Gaming": 0,
    "AI/ LLM": 0,
  };

  @override
  void initState() {
    super.initState();

    activeFilters = List.from(widget.filters);

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

  void _incrementRecommendations() {
    setState(() {
      recommendationCount++;
      _controller.forward().then((_) => _controller.reverse());
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  double get totalConsumption {
    double total = 0;
    for (var f in activeFilters) {
      if (f.isSelected) {
        total += categoryConsumption[f.name] ?? 0;
      }
    }
    return total;
  }

  void _generateRandomData() {
    final rng = Random();

    categoryConsumption = {
      "Mining": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "Streaming": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "Gaming": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
      "AI/ LLM": double.parse((rng.nextDouble() * 5).toStringAsFixed(2)),
    };

    dataRate = rng.nextDouble() * 500 + 100;
    recentData = rng.nextDouble() * 1500;
  }

  Future<void> openFilterScreen() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(initialFilters: activeFilters),
      ),
    );

    if (result != null && result is List<FilterOption>) {
      setState(() {
        activeFilters = result;
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: _incrementRecommendations,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bandeau en-tête
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Mining',
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
            ),

            Container(
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
            ),

            const SizedBox(height: 16),

            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thermomètre vertical
                  Column(
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
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
                  ),

                  const SizedBox(width: 16),

                  // Requêtes énergivores
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Requêtes énergivores',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ..._buildEnergyTiles(),
                        const SizedBox(height: 16),

                        /// ✅ Bouton Recommandations AVEC BADGE
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecommendationsScreen(),
                              ),
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
                                child: Row(
                                  children: const [
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          } else if (index == 1) {
            // Puce → ne fait rien
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            );
          } else if (index == 3) {
            // déjà sur Dashboard
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Datarium'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Historique',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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
