import 'dart:convert';

import 'package:flutter/foundation.dart';        // pour kIsWeb et defaultTargetPlatform
import 'package:http/http.dart' as http;
import 'package:datarium/models/data_stats.dart';

class DataService {
  final String baseUrl;
  final http.Client _client;

  DataService({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ??
            (kIsWeb
                ? 'http://localhost:8000'
                : (defaultTargetPlatform == TargetPlatform.android
                    ? 'http://10.0.2.2:8000'
                    : 'http://localhost:8000')),
        _client = client ?? http.Client();

  /// Récupère les stats temps réel pour le réseau [networkId].
  Future<DataStats> fetchDataStats(String networkId) async {
    final uri = Uri.parse('$baseUrl/networkStatsEsp32?networkId=$networkId');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      // Décodage JSON + mapping sur DataStats
      final Map<String, dynamic> body = json.decode(response.body);
      return DataStats.fromJson(body);
    } else {
      throw HttpException(
        'Failed to load stats (status ${response.statusCode})',
      );
    }
  }

  void dispose() => _client.close();
}

/// Exception HTTP personnalisée
class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => 'HttpException: $message';
}
