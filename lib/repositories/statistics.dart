
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/statistics.dart';

class StatisticsRepository {
  final http.Client _client;
  final String _base = "${AppConstants.apiBaseUrl}/users";

  StatisticsRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<UserStatistics?> getStatistics(int userId) async {
    final uri = Uri.parse("$_base/$userId/statistics");
    final resp = await _client.get(uri);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return UserStatistics.fromJson(data);
    }
    return null;
  }
}
