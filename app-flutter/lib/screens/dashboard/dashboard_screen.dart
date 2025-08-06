import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/filter_option.dart';
import '../filters_provider.dart';
import '../../services/data_service.dart';
import 'dashboard_viewmodel.dart';
import 'widgets/consumption_bar.dart';
import 'widgets/main_content.dart';
import '../../l10n/app_localizations.dart';

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
          final filtersProvider = context.watch<FiltersProvider>();
          final activeFilters = filtersProvider.asFilterOptions();
          final totalCons = vm.calculateTotalConsumption(activeFilters);
          final barHeight = totalCons > 20 ? 150.0 : (totalCons / 20) * 150;

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Activité en direct',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  
                  Container(
                    width: double.infinity,
                    color: Colors.green[100],
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
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

                  const SizedBox(height: 16),
                  ConsumptionBar(recentData: vm.recentData),
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
