import 'dart:convert';

import 'package:ecokondo/ecokondo.dart';
import 'package:http/http.dart' as http;

class StatisticsRepository {
  final http.Client _client;

  StatisticsRepository({http.Client? client})
    : _client = client ?? http.Client();

  /// Busca estatísticas do usuário logado
  Future<UserStatistics?> getUserStatistics() async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/statistics');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserStatistics.fromJson(data);
      } else {
        print('[ERROR] Failed to load statistics: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('[ERROR] Exception fetching statistics: $e');
      return null;
    }
  }
}
