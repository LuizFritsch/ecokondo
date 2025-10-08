import 'dart:convert';

import 'package:ecokondo/ecokondo.dart';
import 'package:http/http.dart' as http;

class CitiesRepository {
  final http.Client _client;

  CitiesRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<City>> list() async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/cities');
    final res = await _client.get(uri);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data.map((e) => City.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch cities (${res.statusCode})');
  }

  Future<List<ExchangePoint>> exchangePoints(int cityId) async {
    final uri = Uri.parse(
      '${AppConstants.apiBaseUrl}/cities/$cityId/exchange-points',
    );
    final res = await _client.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List<dynamic>;
      return data
          .map((e) => ExchangePoint.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to fetch exchange points (${res.statusCode})');
  }
}
