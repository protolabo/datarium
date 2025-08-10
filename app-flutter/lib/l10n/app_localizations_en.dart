// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get headerTitle => 'Live activity';

  @override
  String get recommendations => 'Recommendations';

  @override
  String labelThroughput(num rate) {
    return 'Throughput: $rate B/s';
  }

  @override
  String labelDuration(num seconds) {
    return 'Duration: ${seconds}s';
  }

  @override
  String recentData(num recent) {
    return 'Last 5 min: $recent B/s';
  }

  @override
  String networkLabel(String id) {
    return 'Network: $id';
  }

  @override
  String get usageLow => 'Low usage';

  @override
  String get usageMedium => 'Moderate usage';

  @override
  String get usageHigh => 'High usage';

  @override
  String get energyRequests => 'Power-hungry requests';

  @override
  String get noFilterSelected => 'No filter selected.';
}
