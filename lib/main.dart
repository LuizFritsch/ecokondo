import 'package:ecokondo/auth_repository.dart';
import 'package:ecokondo/user_home.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'login.dart';

void main() {
  runApp(const EcoKondoApp());
}

class EcoKondoApp extends StatelessWidget {
  const EcoKondoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final AuthRepository _authRepository = AuthRepository();
  bool _loading = true;
  Widget _screen = const LoginScreen();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    final loggedIn = await _authRepository.isLoggedIn();
    setState(() {
      _screen = loggedIn ? const HomeScreen() : const LoginScreen();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : _screen;
  }
}
