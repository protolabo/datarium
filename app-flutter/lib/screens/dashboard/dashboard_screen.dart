import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datarium/l10n/app_localizations.dart';
import 'package:datarium/models/filter_option.dart';
import 'package:datarium/screens/filters_provider.dart';
import 'package:datarium/services/data_service.dart';

import 'dashboard_viewmodel.dart';
import 'widgets/consumption_bar.dart';
import 'widgets/main_content.dart';

class DashboardScreen extends StatelessWidget {
  final String networkId;
  const DashboardScreen({Key? key, required this.networkId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return ChangeNotifierProvider<DashboardViewModel>(
      create: (_) {
        final vm = DashboardViewModel(DataService());
        vm.init(networkId);
        return vm;
      },
      child: Consumer<DashboardViewModel>(
        builder: (context, vm, _) {
          // ✅ on récupère des FilterOption, pas des String
          final List<FilterOption> activeFilters =
              context.watch<FiltersProvider>().asFilterOptions();

          final totalCons = vm.calculateTotalConsumption(activeFilters);
          final barHeight = totalCons > 20 ? 150.0 : (totalCons / 20) * 150.0;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () => Navigator.pop(context),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.dashboardTitle,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Réseau : $networkId',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    '${vm.recommendationCount}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Activité en direct',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Débit (oct/s) & durée (s)
                  Container(
                    width: double.infinity,
                    color: Colors.green[100],
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Débit : ${vm.dataRate.toStringAsFixed(1)} oct/s',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Durée : ${vm.duration}s'),
                      ],
                    ),
                  ),

                  // ✅ Unique bandeau "Dernières 5 min" (unité correcte : oct)
                  Container(
                    width: double.infinity,
                    color: Colors.green[400],
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      'Dernières 5 min : ${vm.recentData.toStringAsFixed(0)} oct',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Jauge verticale
                  ConsumptionBar(recentData: vm.recentData),

                  // Cartes + recommandations
                  MainContent(
                    filters: activeFilters, // <- List<FilterOption>
                    categoryConsumption: vm.categoryConsumption,
                    recommendationCount: vm.recommendationCount,
                    barHeight: barHeight,
                    totalConsumption: totalCons,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
