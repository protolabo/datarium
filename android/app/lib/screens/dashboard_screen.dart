/*


import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../models/filter_option.dart';
import 'filter_screen.dart';

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

  double miningConsumption = 0;
  double streamingConsumption = 0;
  double gamingConsumption = 0;
  double aiConsumption = 0;

  List<FilterOption> activeFilters = [];

  @override
  void initState() {
    super.initState();

    activeFilters = widget.filters.where((f) => f.isSelected).toList();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        dataRate = Random().nextDouble() * 500 + 100;
        duration += 1;
        recentData = Random().nextDouble() * 1000;

        miningConsumption = Random().nextDouble() * 5;
        streamingConsumption = Random().nextDouble() * 5;
        gamingConsumption = Random().nextDouble() * 5;
        aiConsumption = Random().nextDouble() * 5;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalConsumption = 0;
    if (activeFilters.any((f) => f.name == "Mining")) {
      totalConsumption += miningConsumption;
    }
    if (activeFilters.any((f) => f.name == "Streaming")) {
      totalConsumption += streamingConsumption;
    }
    if (activeFilters.any((f) => f.name == "Gaming")) {
      totalConsumption += gamingConsumption;
    }
    if (activeFilters.any((f) => f.name == "AI/ LLM")) {
      totalConsumption += aiConsumption;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Activité en direct',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
            // Ligne des stats principales
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Mining',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
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
                        'Débit : ${dataRate.toStringAsFixed(0)} oct/s',
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

            // Données trading
            Container(
              color: Colors.green[300],
              width: double.infinity,
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

            // Bloc gris principal
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Ligne filtrer + barre graph
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icone filtre
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FilterScreen(
                                        initialFilters: activeFilters,
                                      ),
                                ),
                              );

                              if (result != null &&
                                  result is List<FilterOption>) {
                                setState(() {
                                  activeFilters = result;
                                });
                              }
                            },
                            child: const Icon(
                              Icons.filter_list,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Graph vertical
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
                                height:
                                    (totalConsumption / 20) * 150, // max 20 kWh
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[200],
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
                      const SizedBox(width: 16),
                      // Bloc des requêtes énergivores
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Requêtes énergivores',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ..._buildTiles(),
                            const SizedBox(height: 16),
                            // Bouton recommandations
                            Container(
                              width: double.infinity,
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
                          ],
                        ),
                      ),
                    ],
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Temps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon Compte',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTiles() {
    final List<Widget> tiles = [];

    if (activeFilters.any((f) => f.name == "Mining")) {
      tiles.add(_buildEnergyTile("Mining", miningConsumption));
      tiles.add(const SizedBox(height: 16));
    }
    if (activeFilters.any((f) => f.name == "Streaming")) {
      tiles.add(_buildEnergyTile("Streaming", streamingConsumption));
      tiles.add(const SizedBox(height: 16));
    }
    if (activeFilters.any((f) => f.name == "Gaming")) {
      tiles.add(_buildEnergyTile("Gaming", gamingConsumption));
      tiles.add(const SizedBox(height: 16));
    }
    if (activeFilters.any((f) => f.name == "AI/ LLM")) {
      tiles.add(_buildEnergyTile("AI/ LLM", aiConsumption));
      tiles.add(const SizedBox(height: 16));
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

  Widget _buildEnergyTile(String title, double value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${value.toStringAsFixed(2)} kWh',
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
  }
}


*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'filter_screen.dart';
import '../models/filter_option.dart';
import 'settings_screen.dart';

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

  double miningConsumption = 0;
  double streamingConsumption = 0;
  double gamingConsumption = 0;
  double aiConsumption = 0;
  double totalConsumption = 0;

  late List<FilterOption> activeFilters;

  @override
  void initState() {
    super.initState();
    activeFilters =
        widget.filters.where((element) => element.isSelected).toList();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        dataRate = Random().nextDouble() * 500 + 100;
        duration += 1;
        recentData = Random().nextDouble() * 1000;

        miningConsumption = Random().nextDouble() * 5;
        streamingConsumption = Random().nextDouble() * 5;
        gamingConsumption = Random().nextDouble() * 5;
        aiConsumption = Random().nextDouble() * 5;

        totalConsumption =
            miningConsumption +
            streamingConsumption +
            gamingConsumption +
            aiConsumption;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void openFilterScreen() async {
    final result = await Navigator.push<List<FilterOption>>(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(initialFilters: widget.filters),
      ),
    );

    if (result != null) {
      setState(() {
        activeFilters = result.where((f) => f.isSelected).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Activité en direct',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
            // Ligne Mining + Crypto + Débit + Durée
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Mining',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
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
                        'Débit : ${dataRate.toStringAsFixed(0)} oct/s',
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

            // Données trading (bande verte)
            Container(
              color: Colors.green[400],
              width: double.infinity,
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

            // Bloc gris principal
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bloc gauche : filtre + barre verticale
                      Column(
                        children: [
                          GestureDetector(
                            onTap: openFilterScreen,
                            child: const Icon(
                              Icons.filter_list,
                              color: Colors.black,
                            ),
                          ),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[200],
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

                      const SizedBox(width: 16),

                      // Bloc droit : requêtes énergivores
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

                            // Bouton recommandations
                            Container(
                              width: double.infinity,
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
                          ],
                        ),
                      ),
                    ],
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
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Temps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon Compte',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEnergyTiles() {
    final tiles = <Widget>[];

    for (var f in activeFilters) {
      double value = 0;

      switch (f.name) {
        case 'Mining':
          value = miningConsumption;
          break;
        case 'Streaming':
          value = streamingConsumption;
          break;
        case 'Gaming':
          value = gamingConsumption;
          break;
        case 'AI/ LLM':
          value = aiConsumption;
          break;
      }

      tiles.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
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
                      '${value.toStringAsFixed(2)} kWh',
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
        ),
      );
    }

    return tiles;
  }
}
