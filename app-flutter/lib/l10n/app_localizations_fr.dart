// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get headerTitle => 'Activité en direct';

  @override
  String get labelStreaming => 'Streaming';

  @override
  String get labelCrypto => 'Crypto Ex…';

  @override
  String labelThroughput(Object rate) {
    return 'Débit : $rate oct/s';
  }

  @override
  String labelDuration(Object seconds) {
    return 'Durée : ${seconds}s';
  }

  @override
  String recentData(Object recent) {
    return 'Dernières 5 min : $recent oct/s';
  }

  @override
  String get energyRequests => 'Requêtes énergivores';

  @override
  String get noFilterSelected => 'Aucun filtre sélectionné.';

  @override
  String get highUsage => 'Utilisation élevée';

  @override
  String get recommendations => 'Recommandations';
}
