import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/filter_option.dart';
import '../filters_provider.dart';
import '../../services/data_service.dart';
import 'dashboard_viewmodel.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/consumption_bar.dart';
import 'widgets/main_content.dart';
import '../../l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return ChangeNotifierProvider<DashboardViewModel>(
      create: (_) {
        final vm = DashboardViewModel(DataService());
        vm.init();
        return vm;
      },
      child: Consumer<DashboardViewModel>(
        builder: (context, vm, _) {
          final filtersProvider = context.watch<FiltersProvider>();
          final activeFilters = filtersProvider.asFilterOptions();
          final totalConsumption = vm.calculateTotalConsumption(activeFilters);
          final barHeight =
              totalConsumption > 20 ? 150.0 : (totalConsumption / 20) * 150;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                loc.dashboardTitle,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () => Navigator.pop(context),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: vm.incrementRecommendations,
                  tooltip: loc.recommendations,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  DashboardHeader(
                    dataRate: vm.dataRate,
                    duration: vm.duration,
                  ),
                  ConsumptionBar(recentData: vm.recentData),
                  MainContent(
                    filters: activeFilters,
                    categoryConsumption: vm.categoryConsumption,
                    recommendationCount: vm.recommendationCount,
                    barHeight: barHeight,
                    totalConsumption: totalConsumption,
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
