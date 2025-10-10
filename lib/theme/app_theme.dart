
import 'package:flutter/material.dart';

class AppColors {
  static const primary    = Color(0xFF2E8B57);
  static const accent     = Color(0xFFD9822B);
  static const text       = Color(0xFF333333);
  static const background = Color(0xFFF5F5F5);
  static const white      = Color(0xFFFFFFFF);
  static const success = Color(0xFF28A745);
  static const warning = Color(0xFFFFC107);
  static const error   = Color(0xFFDC3545);
}

final TextTheme _lightText = const TextTheme(
  titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text),
  titleMedium: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.text),
  bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: AppColors.text),
  bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: AppColors.text),
);

final TextTheme _darkText = const TextTheme(
  titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
  titleMedium: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
  bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.white),
  bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.white70),
);

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.accent,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      background: AppColors.background,
      onBackground: AppColors.text,
      surface: AppColors.white,
      onSurface: AppColors.text,
    ),
    textTheme: _lightText,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.white,
      indicatorColor: AppColors.primary.withOpacity(0.10),
      labelTextStyle: const MaterialStatePropertyAll(
        TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.text.withOpacity(0.10)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.text.withOpacity(0.10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary, width: 1.2),
      ),
      prefixIconColor: AppColors.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black87,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    dividerColor: AppColors.text.withOpacity(0.08),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.accent,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      background: Color(0xFF121212),
      onBackground: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    textTheme: _darkText,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: Color(0xFF1E1E1E),
      surfaceTintColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: AppColors.primary.withOpacity(0.20),
      labelTextStyle: const MaterialStatePropertyAll(
        TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1E1E1E),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary, width: 1.2),
      ),
      prefixIconColor: AppColors.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white10,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    dividerColor: Colors.white10,
  );
}
