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
  String get recommendations => 'Recommandations';

  @override
  String labelThroughput(num rate) {
    return 'Débit : $rate oct/s';
  }

  @override
  String labelDuration(num seconds) {
    return 'Durée : ${seconds}s';
  }

  @override
  String recentData(num recent) {
    return 'Dernières 5 min : $recent oct';
  }

  @override
  String networkLabel(String id) {
    return 'Réseau : $id';
  }

  @override
  String get usageLow => 'Utilisation faible';

  @override
  String get usageMedium => 'Utilisation modérée';

  @override
  String get usageHigh => 'Utilisation élevée';

  @override
  String get energyRequests => 'Requêtes énergivores';

  @override
  String get noFilterSelected => 'Aucun filtre sélectionné.';
}
