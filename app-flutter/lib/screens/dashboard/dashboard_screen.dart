import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datarium/l10n/app_localizations.dart';
import 'package:datarium/models/filter_option.dart';
import 'package:datarium/screens/filters_provider.dart';
import 'package:datarium/services/data_service.dart';

import 'dashboard_viewmodel.dart';
import 'widgets/consumption_bar.dart';
import 'widgets/main_content.dart';
import 'widgets/dashboard_header.dart'; // <-- important

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
          final List<FilterOption> activeFilters =
              context.watch<FiltersProvider>().asFilterOptions();

          final totalCons = vm.calculateTotalConsumption(activeFilters);
          final barHeight =
              totalCons > 20 ? 150.0 : (totalCons / 20) * 150.0;

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
                  // 
                  DashboardHeader(
                    dataRate: vm.dataRate,
                    duration: vm.duration,
                    recentBytes: vm.recentData,
                  ),

                  const SizedBox(height: 16),

                  // Jauge verticale
                  ConsumptionBar(recentData: vm.recentData),

                  // Cartes + recommandations
                  MainContent(
                    filters: activeFilters,
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
