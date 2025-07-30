import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filter_option.dart';
import 'filters_provider.dart';

class FilterScreen extends StatelessWidget {
  final List<FilterOption> initialFilters;

  const FilterScreen({super.key, required this.initialFilters});

  @override
  Widget build(BuildContext context) {
    final filtersProvider = Provider.of<FiltersProvider>(
      context,
      listen: false,
    );

    // On clone les filtres pour ne pas modifier les originaux directement
    final filters =
        initialFilters
            .map((f) => FilterOption(name: f.name, isSelected: f.isSelected))
            .toList();

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
                  onPressed: () {
                    for (var f in filters) {
                      f.isSelected = true;
                    }
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text("Tout sélectionner"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    for (var f in filters) {
                      f.isSelected = false;
                    }
                    (context as Element).markNeedsBuild();
                  },
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
                      option.isSelected = !option.isSelected;
                      (context as Element).markNeedsBuild();
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
                    onPressed: () {
                      for (var f in filters) {
                        f.isSelected = false;
                      }
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text("Effacer"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      filtersProvider.setFromFilterOptions(filters);
                      Navigator.pop(
                        context,
                        filters,
                      ); // Retourne les filtres sélectionnés avec l'icone filtre dans le dashbord
                    },
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
