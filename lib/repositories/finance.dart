import 'dart:convert';

import 'package:ecokondo/ecokondo.dart';
import 'package:http/http.dart' as http;

class FinanceRepository {
  final http.Client _client;
  final fullPath = "${AppConstants.apiBaseUrl}/finance";

  FinanceRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<FinanceData> getFinanceData() async {
    final uri = Uri.parse(fullPath);

    try {
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FinanceData.fromJson(data);
      } else {
        throw Exception(
          'Erro ao buscar dados financeiros: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro na requisição financeira: $e');
    }
  }
}
