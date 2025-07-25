/*
import 'package:flutter/material.dart';
import '../models/filter_option.dart';

class FilterScreen extends StatefulWidget {
  final List<FilterOption> filters;

  const FilterScreen({super.key, required this.filters});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late List<FilterOption> _filters;

  @override
  void initState() {
    super.initState();
    _filters =
        widget.filters
            .map((f) => FilterOption(name: f.name, isSelected: f.isSelected))
            .toList();
  }

  void toggleSelectAll(bool selectAll) {
    setState(() {
      for (var f in _filters) {
        f.isSelected = selectAll;
      }
    });
  }

  void clearAll() {
    toggleSelectAll(false);
  }

  void applyFilters() {
    Navigator.pop(context, _filters);
  }

  @override
  Widget build(BuildContext context) {
    bool allSelected = _filters.every((f) => f.isSelected);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtres"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () => toggleSelectAll(!allSelected),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade600,
              ),
              child: Text(
                allSelected ? "Tout désélectionner" : "Tout sélectionner",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                return ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color:
                        filter.isSelected ? Colors.green : Colors.grey.shade400,
                  ),
                  title: Text(
                    filter.name,
                    style: TextStyle(
                      color:
                          filter.isSelected
                              ? Colors.green.shade700
                              : Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      filter.isSelected = !filter.isSelected;
                    });
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: clearAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("Effacer"),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Appliquer"),
                  ),
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

import 'package:flutter/material.dart';
import '../models/filter_option.dart';

class FilterScreen extends StatefulWidget {
  final List<FilterOption> initialFilters;

  const FilterScreen({super.key, required this.initialFilters});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late List<FilterOption> filters;

  @override
  void initState() {
    super.initState();
    filters =
        widget.initialFilters
            .map((f) => FilterOption(name: f.name, isSelected: f.isSelected))
            .toList();
  }

  void toggleSelectAll(bool value) {
    setState(() {
      for (var f in filters) {
        f.isSelected = value;
      }
    });
  }

  void applyFilters() {
    Navigator.pop(context, filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Filtres",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () => toggleSelectAll(true),
                  child: const Text("Tout sélectionner"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () => toggleSelectAll(false),
                  child: const Text("Tout désélectionner"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final option = filters[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        option.isSelected = !option.isSelected;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            option.isSelected
                                ? Colors.green[400]
                                : Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(
                            option.isSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color:
                                option.isSelected ? Colors.white : Colors.green,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            option.name,
                            style: TextStyle(
                              color:
                                  option.isSelected
                                      ? Colors.white
                                      : Colors.green[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () => toggleSelectAll(false),
                    child: const Text("Effacer"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: applyFilters,
                    child: const Text("Appliquer"),
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
