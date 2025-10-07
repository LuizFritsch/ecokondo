import 'dart:convert';

import 'package:ecokondo/ecokondo.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class StatisticsRepository {
  final http.Client _client;

  StatisticsRepository({http.Client? client})
    : _client = client ?? http.Client();

  /// Busca estatísticas do usuário logado
  Future<UserStatistics?> getUserStatistics() async {
    final fullPath = '${AppConstants.apiBaseUrl}/statistics';
    final url = Uri.parse(fullPath);

    try {
      debugPrint('[REQUEST][STATISTICS] $fullPath');
      final response = await _client.get(url);
      debugPrint('[RESPONSE][STATISTICS] ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserStatistics.fromJson(data);
      } else {
        debugPrint(
          '[RESPONSE][STATISTICS][ERROR] Failed to load statistics: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      debugPrint(
        '[REQUEST][STATISTICS][ERROR] Exception fetching statistics: $e',
      );
      return null;
    }
  }
}
