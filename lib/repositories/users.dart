
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user_profile.dart';

class UsersRepository {
  final http.Client _client;
  UsersRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<UserProfile> getProfile(int userId) async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/users/$userId/profile');
    final res = await _client.get(uri);
    if (res.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to fetch profile (${res.statusCode})');
  }

  Future<int> setPreferredCity(int userId, int cityId) async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/users/$userId/preferred-city');
    final res = await _client.patch(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cityId': cityId}));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['preferredCityId'] as int;
    }
    throw Exception('Failed to set preferred city (${res.statusCode})');
  }
}
