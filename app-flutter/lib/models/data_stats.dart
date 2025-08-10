// lib/models/data_stats.dart
class DataStats {
  /// Octets par seconde
  final double dataRate;
  /// Durée du log (secondes, peut être 0 si inconnu)
  final int duration;
  /// Total d’octets du dernier log
  final double recentData;

  /// Consommation (kWh) par catégorie
  final double streamingConsumption;
  final double gamingConsumption;
  final double aiConsumption;
  final double unknownConsumption;

  const DataStats({
    required this.dataRate,
    required this.duration,
    required this.recentData,
    required this.streamingConsumption,
    required this.gamingConsumption,
    required this.aiConsumption,
    required this.unknownConsumption,
  });

  /// Parse un document renvoyé par /networkLogs/recent
  factory DataStats.fromLogJson(Map<String, dynamic> json) {
    // ---- valeurs réseau ----
    final bytesAny = json['bytes'] ?? json['totalBytes'] ?? json['size'] ?? json['octets'] ?? 0;
    final secsAny  = json['listenSec'] ?? json['durationSec'] ?? json['duration'] ?? json['secs'] ?? 0;

    final double bytes = (bytesAny is num) ? bytesAny.toDouble() : double.tryParse('$bytesAny') ?? 0.0;
    final int secsRaw  = (secsAny  is num) ? secsAny.toInt()  : int.tryParse('$secsAny') ?? 0;
    final int secs     = secsRaw <= 0 ? 1 : secsRaw; // éviter /0 pour le débit

    // ---- valeurs conso ----
    final kwhAny = json['kwh'] ?? json['energyKwh'] ?? json['energy'] ?? 0;
    final double kwh = (kwhAny is num) ? kwhAny.toDouble() : double.tryParse('$kwhAny') ?? 0.0;

    // catégorie tolérante aux variantes : espaces, /, _, -
    String cat = (json['category'] as String? ?? 'unknown').toLowerCase().trim();
    final norm = cat.replaceAll(RegExp(r'[\s/_-]+'), ''); // "ai/ llm" -> "aillm"

    double stream = 0, game = 0, ai = 0, unk = 0;
    if (norm.contains('stream')) {
      stream = kwh;
    } else if (norm.contains('game')) {
      game = kwh;
    } else if (norm == 'ai' || norm == 'llm' || norm == 'aillm') {
      ai = kwh;
    } else {
      unk = kwh; // unknown / autre
    }

    return DataStats(
      dataRate: bytes / secs,
      duration: secsRaw, // on garde la vraie durée (même si 0)
      recentData: bytes,
      streamingConsumption: stream,
      gamingConsumption: game,
      aiConsumption: ai,
      unknownConsumption: unk,
    );
  }

  /// Valeurs neutres quand aucun log n’est dispo
  factory DataStats.empty() => const DataStats(
        dataRate: 0,
        duration: 0,
        recentData: 0,
        streamingConsumption: 0,
        gamingConsumption: 0,
        aiConsumption: 0,
        unknownConsumption: 0,
      );

  double get totalConsumption =>
      streamingConsumption + gamingConsumption + aiConsumption + unknownConsumption;
}
