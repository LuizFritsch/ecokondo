import 'dart:convert';

import 'package:ecokondo/ecokondo.dart';
import 'package:http/http.dart' as http;

class MaterialsRepository {
  final http.Client _client;

  MaterialsRepository({http.Client? client})
    : _client = client ?? http.Client();

  Future<MaterialsResponse> list() async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/materials');
    final res = await _client.get(uri);
    if (res.statusCode == 200) {
      return MaterialsResponse.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Failed to fetch materials (${res.statusCode})');
  }
}
