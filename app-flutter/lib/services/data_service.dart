import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/data_stats.dart';

class DataService {
  static const String _base = 'http://localhost:8000';
  static const int _recentLimit = 10; // <-- limite réduite
  final http.Client _client = http.Client();

  DataStats? _lastGood;            // cache pour mode dégradé
  DateTime? _lastErrorPrintedAt;   // anti-spam logs

  Future<DataStats> fetchLatestLog(String networkId) async {
    final uri = Uri.parse('$_base/networkLogs/recent').replace(
      queryParameters: {
        'networkId': networkId.trim(),
        'limit': '$_recentLimit',   // <-- on fixe la limite à 10
      },
    );

    try {
      final resp = await _client
          .get(uri, headers: {'accept': 'application/json'})
          .timeout(const Duration(seconds: 5));

      if (resp.statusCode != 200) {
        throw Exception('GET $uri -> ${resp.statusCode}');
      }

      final decoded = jsonDecode(resp.body);
      final List list = (decoded is List) ? decoded : const <dynamic>[];

      if (list.isEmpty) {
        return _lastGood ?? DataStats.empty();
      }

      // Agrégation simple des N derniers items
      double bytes = 0;
      int secs = 0;
      double s = 0, g = 0, ai = 0, unk = 0;

      for (final e in list) {
        // tolérant aux types dynamiques
        final m = Map<String, dynamic>.from(e as Map);
        final ds = DataStats.fromLogJson(m);
        bytes += ds.recentData;
        secs  += ds.duration;
        s     += ds.streamingConsumption;
        g     += ds.gamingConsumption;
        ai    += ds.aiConsumption;
        unk   += ds.unknownConsumption;
      }

      final rate = secs <= 0 ? 0.0 : bytes / secs;

      final aggregated = DataStats(
        dataRate: rate,
        duration: secs,
        recentData: bytes,
        streamingConsumption: s,
        gamingConsumption: g,
        aiConsumption: ai,
        unknownConsumption: unk,
      );

      _lastGood = aggregated; // met à jour le cache
      return aggregated;
    } catch (e) {
      // Imprime l’erreur au max toutes les 30s
      final now = DateTime.now();
      if (_lastErrorPrintedAt == null ||
          now.difference(_lastErrorPrintedAt!).inSeconds > 30) {
        debugPrint('DataService fetchLatestLog: $e');
        _lastErrorPrintedAt = now;
      }
      // Mode dégradé
      return _lastGood ?? DataStats.empty();
    }
  }

  void dispose() {
    _client.close();
  }
}
