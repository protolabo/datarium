class DataStats {
  final double dataRate;
  final int duration;
  final double recentData;
  final double miningConsumption; // TODO: Refactor into ConsumptionModel
  final double streamingConsumption; // TODO: Refactor into ConsumptionModel
  final double gamingConsumption; // TODO: Refactor into ConsumptionModel
  final double aiConsumption; // TODO: Refactor into ConsumptionModel

  DataStats({
    required this.dataRate,
    required this.duration,
    required this.recentData,
    required this.miningConsumption,
    required this.streamingConsumption,
    required this.gamingConsumption,
    required this.aiConsumption,
  });

  double get totalConsumption =>
      miningConsumption +
      streamingConsumption +
      gamingConsumption +
      aiConsumption;

  factory DataStats.fromJson(Map<String, dynamic> json) {
    return DataStats(
      dataRate: (json['dataRate'] as num).toDouble(),
      duration: json['duration'] as int,
      recentData: (json['recentData'] as num).toDouble(),
      miningConsumption: (json['miningConsumption'] as num).toDouble(),
      streamingConsumption: (json['streamingConsumption'] as num).toDouble(),
      gamingConsumption: (json['gamingConsumption'] as num).toDouble(),
      aiConsumption: (json['aiConsumption'] as num).toDouble(),
    );
  }
}
