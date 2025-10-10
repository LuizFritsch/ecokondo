
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/finance.dart';

class FinanceRepository {
  final http.Client _client;
  final String _base = "${AppConstants.apiBaseUrl}/users";

  FinanceRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<FinanceData> getFinanceData(int userId) async {
    final uri = Uri.parse("$_base/$userId/finance");
    final resp = await _client.get(uri);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return FinanceData.fromJson(data);
    }
    throw Exception("Failed to load finance (${resp.statusCode})");
  }
}
