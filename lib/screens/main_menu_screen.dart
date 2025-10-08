import 'package:flutter/material.dart';

import '../models/finance.dart';
import '../models/user_profile.dart';
import '../repositories/finance.dart';
import '../repositories/users.dart';
import '../theme/app_theme.dart';
import '../utils/auth_utils.dart';
import 'finance_tab.dart';
import 'home_tab.dart';
import 'profile_tab.dart';
import 'statistics_tab.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final UsersRepository usersRepo = UsersRepository();
  final FinanceRepository financeRepo = FinanceRepository();

  int _currentIndex = 0;
  int? _userId;
  UserProfile? _profile;
  FinanceData? _finance;
  bool _loadingHeader = true;

  @override
  void initState() {
    super.initState();
    _bootstrapHeader();
  }

  Future<void> _bootstrapHeader() async {
    try {
      final id = await getCurrentUserId();
      if (id == null) {
        setState(() => _loadingHeader = false);
        return;
      }
      _userId = id;
      final profile = await usersRepo.getProfile(id);
      final finance = await financeRepo.getFinanceData(id);
      setState(() {
        _profile = profile;
        _finance = finance;
        _loadingHeader = false;
      });
    } catch (_) {
      setState(() => _loadingHeader = false);
    }
  }

  Widget _buildAppBarContent() {
    final name = _profile?.fullName ?? 'Usuário';
    final balanceEK = _finance?.balance ?? 0.0;
    final reais = _finance == null ? 0.0 : (balanceEK * _finance!.ekToReal);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: _loadingHeader
              ? const SizedBox(
                  width: 80,
                  height: 12,
                  child: LinearProgressIndicator(color: AppColors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 18,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${balanceEK.toStringAsFixed(2)} EK',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•  ≈ R\$ ${reais.toStringAsFixed(2)}',
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeTab();
      case 1:
        return const FinanceTab();
      case 2:
        return const StatisticsTab();
      case 3:
        return const ProfileTab();
      default:
        return const HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 96,
        titleSpacing: 16,
        title: _buildAppBarContent(),
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Financeiro',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_graph_outlined),
            selectedIcon: Icon(Icons.auto_graph),
            label: 'Estatísticas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
