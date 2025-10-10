import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<int?> getCurrentUserId() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token == null) return null;
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final payloadMap =
        json.decode(
              utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
            )
            as Map<String, dynamic>;
    return payloadMap['sub'] as int?;
  } catch (_) {
    return null;
  }
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
