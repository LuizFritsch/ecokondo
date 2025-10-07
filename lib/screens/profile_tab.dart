import 'package:flutter/material.dart';

import '../auth_repository.dart';
import '../login.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<void> _logout(BuildContext context) async {
    final repo = AuthRepository();
    await repo.logout();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text('Logout'));
  }
}
