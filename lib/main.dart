import 'package:flutter/material.dart';

import 'login.dart';
import 'screens/main_menu_screen.dart';
import 'theme/app_theme.dart';

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
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainMenuScreen(),
      },
    );
  }
}
