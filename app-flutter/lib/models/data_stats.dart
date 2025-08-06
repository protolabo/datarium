class DataStats {
  /// Octets par seconde
  final double dataRate;

  /// Durée totale d’écoute (en secondes)
  final int duration;

  /// Total d’octets reçus
  final double recentData;

  /// Champs de consommation pour plus tard – provisoirement à 0
  final double miningConsumption;
  final double streamingConsumption;
  final double gamingConsumption;
  final double aiConsumption;

  DataStats({
    required this.dataRate,
    required this.duration,
    required this.recentData,
    required this.miningConsumption,
    required this.streamingConsumption,
    required this.gamingConsumption,
    required this.aiConsumption,
  });

  factory DataStats.fromJson(Map<String, dynamic> json) {
    final bytes = (json['bytes'] as num).toDouble();
    final secs  = json['listenSec'] as int;

    return DataStats(
      dataRate: bytes / secs,    // calculé à partir de bytes / listenSec
      duration: secs,            // listenSec
      recentData: bytes,         // total bytes
      // Consommations détaillées non encore supportées par l'API
      miningConsumption: 0,
      streamingConsumption: 0,
      gamingConsumption: 0,
      aiConsumption: 0,
    );
  }

  /// Somme des consommations (pour usage futur)
  double get totalConsumption =>
      miningConsumption +
      streamingConsumption +
      gamingConsumption +
      aiConsumption;
}
