import 'package:ecokondo/ecokondo.dart';
import 'package:flutter/material.dart';

class EcoKondoAppBar extends StatelessWidget {
  const EcoKondoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppStrings.login),
      backgroundColor: AppColors.primary,
    );
  }
}
