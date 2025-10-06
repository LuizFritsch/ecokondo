import 'package:flutter/material.dart';
import 'login.dart';
import 'constants.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E8B57)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //TODO: Verificar login aqui
    Future.delayed(const Duration(seconds: 2), () {
      if(mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2E8B57);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, color: primaryColor, size: 100),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: primaryColor),
          ],
        ),
      ),
    );
  }
}
