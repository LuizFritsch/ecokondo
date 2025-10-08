import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:ecokondo/models/user_logged_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class AuthRepository {
  final http.Client _client;
  final fullPath = "${AppConstants.apiBaseUrl}/auth";

  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<bool> login({required String email, required String password}) async {
    final url = "$fullPath/login";
    final uri = Uri.parse(url);
    try {
      debugPrint(AppConstants.request(fullPath));
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['access_token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['access_token']);
          debugPrint(AppConstants.saveSharedPreferencesLoginSuccess);
          decryptJWT(data['access_token']);
          await prefs.setInt(
            'auth_login_time',
            DateTime.now().millisecondsSinceEpoch,
          );
          return true;
        }
        debugPrint(AppConstants.saveSharedPreferencesLoginFailed);
        return false;
      } else {
        String error =
            '${AppDebugErrorConstants.loginResponseAPIError} ${response.statusCode} ${response.body}';
        debugPrint(error);
        return false;
      }
    } catch (e) {
      String error = '${AppDebugErrorConstants.loginRequestAPIError} $e';
      debugPrint(error);
      throw Exception(error);
    }
  }

  decryptJWT(String jwtToken) {
    final jwt = JWT.verify(
      jwtToken,
      SecretKey(
        'DO NOT USE THIS VALUE. INSTEAD, CREATE A COMPLEX SECRET AND KEEP IT SAFE OUTSIDE OF THE SOURCE CODE.',
      ),
    );
    debugPrint('Payload: ${jwt.payload}');

    final user = AuthPayload.fromJson(jwt.payload);

    debugPrint(user.username);
  }

  Future<AuthPayload?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();

    // Verifica se há token salvo
    final token = prefs.getString('auth_token');
    if (token == null) {
      debugPrint('Nenhum token salvo.');
      return null;
    }

    try {
      // Decodifica o JWT (sem verificar assinatura, já que é um token local)
      final parts = token.split('.');
      if (parts.length != 3) {
        debugPrint('Token JWT inválido.');
        return null;
      }

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final user = AuthPayload.fromJson(payload);

      debugPrint('Usuário recuperado: ${user.username} (${user.userType})');
      return user;
    } catch (e) {
      debugPrint('Erro ao decodificar token: $e');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('auth_token') ||
        !prefs.containsKey('auth_login_time')) {
      debugPrint('Usuário não logado');
      await logout();
      return false;
    }

    final loginTime = prefs.getInt('auth_login_time')!;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Sessão válida por 24 horas
    const sessionDuration = Duration(minutes: 30);
    final timeLeft = loginTime + sessionDuration.inMilliseconds - now;

    if (timeLeft <= 0) {
      debugPrint('Sessão expirada');
      await logout();
      return false;
    } else {
      final hoursLeft = (timeLeft / (1000 * 60 * 60)).floor();
      final minutesLeft = ((timeLeft % (1000 * 60 * 60)) / (1000 * 60)).floor();
      debugPrint(
        'Sessão válida: $hoursLeft horas e $minutesLeft minutos restantes',
      );
      return true;
    }
  }
}
