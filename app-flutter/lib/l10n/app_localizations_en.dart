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
  String get headerTitle => 'Live Activity';

  @override
  String get labelStreaming => 'Streaming';

  @override
  String get labelCrypto => 'Crypto Ex…';

  @override
  String labelThroughput(Object rate) {
    return 'Throughput: $rate oct/s';
  }

  @override
  String labelDuration(Object seconds) {
    return 'Duration: ${seconds}s';
  }

  @override
  String recentData(Object recent) {
    return 'Last 5 min: $recent oct/s';
  }

  @override
  String get energyRequests => 'Energy-hungry requests';

  @override
  String get noFilterSelected => 'No filters selected.';

  @override
  String get highUsage => 'High usage';

  @override
  String get recommendations => 'Recommendations';
}
