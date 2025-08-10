/*

// history_screen.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';

import '../../models/filter_option.dart';
import '../dashboard/dashboard_screen.dart';
import '../profil/profile_screen.dart';

enum Period { day, week, month, custom }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> dummyHistory = [
    {"time": "2025-07-30 10:00", "app": "Streaming", "kwh": "1.2"},
    {"time": "2025-07-16 17:15", "app": "Streaming", "kwh": "0.8"},
    {"time": "2025-07-16 16:59", "app": "Gaming", "kwh": "1.0"},
    {"time": "2025-07-15 11:10", "app": "AI/ LLM", "kwh": "0.5"},
    {"time": "2025-07-30 10:00", "app": "Streaming", "kwh": "1.2"},
    {"time": "2025-07-30 11:00", "app": "Gaming", "kwh": "0.7"},
    {"time": "2025-07-30 12:00", "app": "AI/ LLM", "kwh": "0.5"},
    {"time": "2025-07-29 09:00", "app": "Streaming", "kwh": "0.6"},
    {"time": "2025-07-29 10:00", "app": "Gaming", "kwh": "0.4"},
  ];

  Period selectedPeriod = Period.day;
  DateTimeRange? customRange;
  List<String> selectedCategories = ["Streaming", "Gaming", "AI/ LLM"];
  bool filtersExpanded = false;

  final appColors = {
    "Streaming": Colors.blue,
    "Gaming": Colors.purple,
    "AI/ LLM": Colors.yellow[700]!,
  };

  Future<void> exportCSV() async {
    final csvRows = <String>["Date,Time,App,kWh"];
    for (var item in dummyHistory) {
      csvRows.add(
        "${item["time"]!.replaceAll(" ", ",")},${item["app"]},${item["kwh"]}",
      );
    }
    final bytes = utf8.encode(csvRows.join("\n"));
    final fileBytes = Uint8List.fromList(bytes);
    await FileSaver.instance.saveFile(
      name: "datarium_history.csv",
      bytes: fileBytes,
      mimeType: MimeType.csv,
    );
  }

  List<Map<String, String>> getFilteredHistory() {
    final now = DateTime.now();
    return dummyHistory.where((item) {
      final date = DateFormat('yyyy-MM-dd HH:mm').parse(item["time"]!);
      final inCategory = selectedCategories.contains(item["app"]);
      if (!inCategory) return false;
      switch (selectedPeriod) {
        case Period.day:
          final startOfDay = DateTime(now.year, now.month, now.day);
          final endOfNow = now;
          return date.isAfter(
                startOfDay.subtract(const Duration(seconds: 1)),
              ) &&
              date.isBefore(endOfNow.add(const Duration(seconds: 1)));
        case Period.week:
          return date.isAfter(now.subtract(const Duration(days: 7)));
        case Period.month:
          return date.isAfter(now.subtract(const Duration(days: 30)));
        case Period.custom:
          if (customRange == null) return true;
          return date.isAfter(
                customRange!.start.subtract(const Duration(days: 1)),
              ) &&
              date.isBefore(customRange!.end.add(const Duration(days: 1)));
      }
    }).toList();
  }

  void resetFilters() {
    setState(() {
      selectedPeriod = Period.day;
      customRange = null;
      selectedCategories = appColors.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredHistory();

    final dailyAppTotals = <String, Map<String, double>>{};
    for (var item in filtered) {
      final day = item["time"]!.split(" ")[0];
      final app = item["app"]!;
      final kwh = double.parse(item["kwh"]!);
      dailyAppTotals.putIfAbsent(day, () => {});
      dailyAppTotals[day]!.update(app, (v) => v + kwh, ifAbsent: () => kwh);
    }

    final sortedDays = dailyAppTotals.keys.toList()..sort();
    final maxY =
        dailyAppTotals.isEmpty
            ? 1.0
            : dailyAppTotals.values
                    .expand((m) => m.values)
                    .fold(0.0, (a, b) => a > b ? a : b) +
                1;
    final totalConsumption = filtered.fold<double>(
      0,
      (sum, item) => sum + double.parse(item["kwh"]!),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historique",
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
            icon: const Icon(Icons.download, color: Colors.green),
            onPressed: exportCSV,
          ),
        ],
      ),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: 1.0,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.green[100],
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Total consommation : ${totalConsumption.toStringAsFixed(2)} kWh",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ExpansionTile(
                title: const Text(
                  "Filtres avancés",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: filtersExpanded,
                onExpansionChanged:
                    (expanded) => setState(() => filtersExpanded = expanded),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text("Jour"),
                          selected: selectedPeriod == Period.day,
                          onSelected:
                              (_) =>
                                  setState(() => selectedPeriod = Period.day),
                        ),
                        ChoiceChip(
                          label: const Text("Semaine"),
                          selected: selectedPeriod == Period.week,
                          onSelected:
                              (_) =>
                                  setState(() => selectedPeriod = Period.week),
                        ),
                        ChoiceChip(
                          label: const Text("Mois"),
                          selected: selectedPeriod == Period.month,
                          onSelected:
                              (_) =>
                                  setState(() => selectedPeriod = Period.month),
                        ),
                        ChoiceChip(
                          label: const Text("Personnalisé"),
                          selected: selectedPeriod == Period.custom,
                          onSelected: (_) async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2024),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                customRange = picked;
                                selectedPeriod = Period.custom;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children:
                          appColors.entries.map((entry) {
                            return FilterChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: entry.value,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(entry.key),
                                ],
                              ),
                              selected: selectedCategories.contains(entry.key),
                              onSelected: (val) {
                                setState(() {
                                  if (val) {
                                    selectedCategories.add(entry.key);
                                  } else {
                                    selectedCategories.remove(entry.key);
                                  }
                                });
                              },
                              selectedColor: entry.value.withOpacity(0.3),
                            );
                          }).toList(),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: resetFilters,
                    icon: const Icon(Icons.restart_alt, color: Colors.grey),
                    label: const Text(
                      "Réinitialiser",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _getChartTitle(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child:
                    sortedDays.isEmpty
                        ? Center(
                          child: Text(
                            "Aucune donnée pour la période sélectionnée.",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                        : BarChart(
                          BarChartData(
                            maxY: maxY,
                            groupsSpace: 12,
                            barGroups: List.generate(sortedDays.length, (
                              index,
                            ) {
                              final date = sortedDays[index];
                              final apps = dailyAppTotals[date]!;
                              final rods =
                                  apps.entries
                                      .map(
                                        (e) => BarChartRodData(
                                          toY: e.value,
                                          color: appColors[e.key],
                                          width: 10,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      )
                                      .toList();
                              return BarChartGroupData(
                                x: index,
                                barRods: rods,
                                barsSpace: 4,
                              );
                            }),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget:
                                      (value, _) => Text(
                                        "${value.toStringAsFixed(1)} kWh",
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) {
                                    if (value.toInt() < sortedDays.length) {
                                      return Text(
                                        sortedDays[value.toInt()].substring(5),
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Wrap(
                  spacing: 16,
                  children:
                      appColors.entries
                          .map(
                            (e) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  color: e.value,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  e.key,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                ),
              ),
              const SizedBox(height: 8),
              ..._buildGroupedHistory(filtered),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedHistory(List<Map<String, String>> history) {
    final grouped = <String, List<Map<String, String>>>{};
    for (var item in history) {
      final date = item["time"]!.split(" ")[0];
      grouped.putIfAbsent(date, () => []).add(item);
    }
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return sortedDates.map((date) {
      final entries = grouped[date]!;
      final total = entries.fold<double>(
        0,
        (sum, item) => sum + double.parse(item["kwh"]!),
      );
      return ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          "$date - Total : ${total.toStringAsFixed(1)} kWh",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        children:
            entries
                .map(
                  (item) => ListTile(
                    leading: Icon(
                      _getIconForApp(item["app"]!),
                      color: Colors.green,
                    ),
                    title: Text("${item["app"]} - ${item["kwh"]} kWh"),
                    subtitle: Text(item["time"]!),
                  ),
                )
                .toList(),
      );
    }).toList();
  }

  IconData _getIconForApp(String app) {
    switch (app) {
      case "Streaming":
        return Icons.movie;
      case "Gaming":
        return Icons.sports_esports;
      case "AI/ LLM":
        return Icons.lightbulb;
      default:
        return Icons.device_unknown;
    }
  }

  String _getChartTitle() {
    switch (selectedPeriod) {
      case Period.day:
        return "Consommation énergétique journalière (kWh)";
      case Period.week:
        return "Consommation énergétique hebdomadaire (kWh)";
      case Period.month:
        return "Consommation énergétique mensuelle (kWh)";
      case Period.custom:
        return "Consommation énergétique personnalisée (kWh)";
      default:
        return "Consommation énergétique (kWh)";
    }
  }
}
*/


// lib/screens/history/history_screen.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Period { day, week, month, custom }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // --- Données d’exemple ---
  final List<Map<String, String>> dummyHistory = [
    {"time": "2025-07-30 10:00", "app": "Streaming", "kwh": "1.2"},
    {"time": "2025-07-16 17:15", "app": "Streaming", "kwh": "0.8"},
    {"time": "2025-07-16 16:59", "app": "Gaming", "kwh": "1.0"},
    {"time": "2025-07-15 11:10", "app": "AI/ LLM", "kwh": "0.5"},
    {"time": "2025-07-30 11:00", "app": "Gaming", "kwh": "0.7"},
    {"time": "2025-07-30 12:00", "app": "AI/ LLM", "kwh": "0.5"},
    {"time": "2025-07-29 09:00", "app": "Streaming", "kwh": "0.6"},
    {"time": "2025-07-29 10:00", "app": "Gaming", "kwh": "0.4"},
    // Ajoute des lignes "Unknown" si tu veux tester l’affichage côté historique:
    // {"time": "2025-07-29 11:00", "app": "Unknown", "kwh": "0.3"},
  ];

  // --- État des filtres ---
  Period selectedPeriod = Period.day;
  DateTimeRange? customRange;
  bool filtersExpanded = false;

  // Palette par catégorie (inclut Unknown)
  final Map<String, Color> appColors = {
    "Streaming": Colors.blue,
    "Gaming": Colors.purple,
    "AI/ LLM": Colors.yellow.shade700,
    "Unknown": Colors.grey,
  };

  // Par défaut, on sélectionne toutes les catégories (y compris Unknown)
  late List<String> selectedCategories =
      appColors.keys.toList(growable: true);

  // --- Export CSV ---
  Future<void> exportCSV() async {
    final rows = <String>["Date,Time,App,kWh"];
    for (final item in dummyHistory) {
      rows.add(
        "${item["time"]!.replaceAll(" ", ",")},${item["app"]},${item["kwh"]}",
      );
    }
    final bytes = Uint8List.fromList(utf8.encode(rows.join("\n")));
    await FileSaver.instance.saveFile(
      name: "datarium_history.csv",
      bytes: bytes,
      mimeType: MimeType.csv,
    );
  }

  // --- Filtrage ---
  List<Map<String, String>> getFilteredHistory() {
    final now = DateTime.now();

    return dummyHistory.where((item) {
      final date = DateFormat('yyyy-MM-dd HH:mm').parse(item["time"]!);
      final inCategory = selectedCategories.contains(item["app"]);
      if (!inCategory) return false;

      switch (selectedPeriod) {
        case Period.day:
          final startOfDay = DateTime(now.year, now.month, now.day);
          return date.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
              date.isBefore(now.add(const Duration(seconds: 1)));
        case Period.week:
          return date.isAfter(now.subtract(const Duration(days: 7)));
        case Period.month:
          return date.isAfter(now.subtract(const Duration(days: 30)));
        case Period.custom:
          if (customRange == null) return true;
          // petite marge aux bornes
          return date.isAfter(customRange!.start.subtract(const Duration(days: 1))) &&
              date.isBefore(customRange!.end.add(const Duration(days: 1)));
      }
    }).toList();
  }

  void resetFilters() {
    setState(() {
      selectedPeriod = Period.day;
      customRange = null;
      selectedCategories = appColors.keys.toList(); // garde Unknown
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredHistory();

    // Agrégation par jour & par app
    final dailyAppTotals = <String, Map<String, double>>{};
    for (final item in filtered) {
      final day = item["time"]!.split(" ")[0];
      final app = item["app"]!;
      final kwh = double.parse(item["kwh"]!);
      dailyAppTotals.putIfAbsent(day, () => {});
      dailyAppTotals[day]!.update(app, (v) => v + kwh, ifAbsent: () => kwh);
    }

    final sortedDays = dailyAppTotals.keys.toList()..sort();
    final maxY = dailyAppTotals.isEmpty
        ? 1.0
        : dailyAppTotals.values
                .expand((m) => m.values)
                .fold<double>(0, (a, b) => a > b ? a : b) +
            1.0;

    final totalConsumption = filtered.fold<double>(
      0,
      (sum, item) => sum + double.parse(item["kwh"]!),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historique",
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
            icon: const Icon(Icons.download, color: Colors.green),
            onPressed: exportCSV,
          ),
        ],
      ),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Bandeau total
              Container(
                color: Colors.green[100],
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Total consommation : ${totalConsumption.toStringAsFixed(2)} kWh",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Filtres avancés
              ExpansionTile(
                title: const Text(
                  "Filtres avancés",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: filtersExpanded,
                onExpansionChanged: (v) => setState(() => filtersExpanded = v),
                children: [
                  // Période
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text("Jour"),
                          selected: selectedPeriod == Period.day,
                          onSelected: (_) =>
                              setState(() => selectedPeriod = Period.day),
                        ),
                        ChoiceChip(
                          label: const Text("Semaine"),
                          selected: selectedPeriod == Period.week,
                          onSelected: (_) =>
                              setState(() => selectedPeriod = Period.week),
                        ),
                        ChoiceChip(
                          label: const Text("Mois"),
                          selected: selectedPeriod == Period.month,
                          onSelected: (_) =>
                              setState(() => selectedPeriod = Period.month),
                        ),
                        ChoiceChip(
                          label: const Text("Personnalisé"),
                          selected: selectedPeriod == Period.custom,
                          onSelected: (_) async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2024),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                customRange = picked;
                                selectedPeriod = Period.custom;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Catégories (inclut Unknown)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: appColors.entries.map((entry) {
                        final isOn = selectedCategories.contains(entry.key);
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                color: entry.value,
                              ),
                              const SizedBox(width: 6),
                              Text(entry.key),
                            ],
                          ),
                          selected: isOn,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                if (!selectedCategories.contains(entry.key)) {
                                  selectedCategories.add(entry.key);
                                }
                              } else {
                                selectedCategories.remove(entry.key);
                              }
                            });
                          },
                          selectedColor: entry.value.withOpacity(0.3),
                        );
                      }).toList(),
                    ),
                  ),

                  TextButton.icon(
                    onPressed: resetFilters,
                    icon: const Icon(Icons.restart_alt, color: Colors.grey),
                    label: const Text("Réinitialiser",
                        style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Titre du graphe
              Text(
                _chartTitleFor(selectedPeriod),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),

              // Graphe
              SizedBox(
                height: 250,
                child: sortedDays.isEmpty
                    ? Center(
                        child: Text(
                          "Aucune donnée pour la période sélectionnée.",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : BarChart(
                        BarChartData(
                          maxY: maxY,
                          groupsSpace: 12,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (v, _) => Text(
                                  "${v.toStringAsFixed(1)} kWh",
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) {
                                  final i = v.toInt();
                                  if (i >= 0 && i < sortedDays.length) {
                                    return Text(
                                      sortedDays[i].substring(5),
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(sortedDays.length, (index) {
                            final date = sortedDays[index];
                            final apps = dailyAppTotals[date]!;
                            final rods = apps.entries
                                .map(
                                  (e) => BarChartRodData(
                                    toY: e.value,
                                    color: appColors[e.key],
                                    width: 10,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                )
                                .toList();
                            return BarChartGroupData(
                              x: index,
                              barRods: rods,
                              barsSpace: 4,
                            );
                          }),
                        ),
                      ),
              ),

              // Légende
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Wrap(
                  spacing: 16,
                  children: appColors.entries.map((e) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 12, height: 12, color: e.value),
                        const SizedBox(width: 4),
                        Text(e.key, style: const TextStyle(fontSize: 12)),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              // Liste groupée par jour
              ..._buildGroupedHistory(filtered),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helpers UI ---
  List<Widget> _buildGroupedHistory(List<Map<String, String>> history) {
    final grouped = <String, List<Map<String, String>>>{};
    for (final item in history) {
      final date = item["time"]!.split(" ")[0];
      grouped.putIfAbsent(date, () => []).add(item);
    }
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return sortedDates.map((date) {
      final entries = grouped[date]!;
      final total = entries.fold<double>(
          0, (sum, item) => sum + double.parse(item["kwh"]!));

      return ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          "$date - Total : ${total.toStringAsFixed(1)} kWh",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        children: entries.map((item) {
          final app = item["app"]!;
          final kwh = item["kwh"]!;
          return ListTile(
            leading: Icon(_iconFor(app), color: Colors.green),
            title: Text("$app - $kwh kWh"),
            subtitle: Text(item["time"]!),
          );
        }).toList(),
      );
    }).toList();
  }

  IconData _iconFor(String app) {
    switch (app) {
      case "Streaming":
        return Icons.movie;
      case "Gaming":
        return Icons.sports_esports;
      case "AI/ LLM":
        return Icons.lightbulb;
      case "Unknown":
        return Icons.device_unknown;
      default:
        return Icons.apps;
    }
  }

  String _chartTitleFor(Period p) {
    switch (p) {
      case Period.day:
        return "Consommation énergétique journalière (kWh)";
      case Period.week:
        return "Consommation énergétique hebdomadaire (kWh)";
      case Period.month:
        return "Consommation énergétique mensuelle (kWh)";
      case Period.custom:
        return "Consommation énergétique personnalisée (kWh)";
    }
  }
}
