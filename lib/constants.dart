import 'package:flutter/material.dart';

class AppDebugErrorConstants {
  static const loginRequestAPIError =
      '[REQUEST][ERROR][LOGIN-API] Login-API error:';
  static const loginResponseAPIError =
      '[RESPONSE][ERROR][LOGIN-API] Login-API error:';
}

class AppConstants {
  static const apiBaseUrl = 'http://192.168.15.16:3000';

  static String request(String path) => '[REQUEST] $apiBaseUrl$path';

  static const saveSharedPreferencesLoginSuccess =
      '[SHARED-PREFERENCES] Shared preferences saved. User logged-in.';
  static const saveSharedPreferencesLoginFailed =
      '[SHARED-PREFERENCES] Shared preferences failed to save. User not logged-in.';
}

class AppStrings {
  static const appName = 'Eco Kondo';
  static const login = 'Login';
  static const email = 'Email';
  static const senha = 'Senha';
  static const cadastrar = 'Cadastrar';
}

class AppColors {
  static const Color primary = Color(0xFF2E8B57);
  static const Color accent = Color(0xFFD9822B);
  static const Color background = Colors.white;
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
