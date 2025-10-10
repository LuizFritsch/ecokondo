import 'dart:convert';

import 'package:ecokondo/ecokondo.dart';
import 'package:http/http.dart' as http;

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

  Future<List<Purchase>> getPurchases(int userId) async {
    final uri = Uri.parse(
      '${AppConstants.apiBaseUrl}/finance/purchases/$userId',
    );
    final res = await _client.get(uri);

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      final purchases = (jsonData['purchases'] as List<dynamic>? ?? [])
          .map((e) => Purchase.fromJson(e))
          .toList();
      return purchases;
    } else {
      throw Exception('Erro ao carregar histórico de compras');
    }
  }
}
