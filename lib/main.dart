
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_menu_screen.dart';

void main() {
  runApp(const EcoKondoApp());
}

class EcoKondoApp extends StatelessWidget {
  const EcoKondoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Kondo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const MainMenuScreen(),
    );
  }
}
