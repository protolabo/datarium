import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/data_stats.dart';

class DataService {
  final String baseUrl;
  final http.Client _client;

  DataService({String? baseUrl, http.Client? client})
    : baseUrl =
          baseUrl ??
          (Platform.isAndroid
              ? 'http://10.0.2.2:8000'
              : 'http://localhost:8000'),
      _client = client ?? http.Client();

  Future<DataStats> fetchDataStats() async {
    final uri = Uri.parse('$baseUrl/stats');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      return DataStats.fromJson(jsonBody);
    } else {
      throw HttpException(
        'Failed to load stats (status ${response.statusCode})',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => 'HttpException: $message';
}
