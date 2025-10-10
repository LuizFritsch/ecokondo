import 'package:flutter/material.dart';

import '../models/finance.dart';
import '../models/user_profile.dart';
import '../repositories/finance.dart';
import '../repositories/users.dart';
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
      final userId = await getCurrentUserId();

      if (userId == null) {
        // ✅ se não estiver logado, vai pra tela de login
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
        }
        return;
      }

      _userId = userId;

      final profile = await usersRepo.getProfile(userId);
      final finance = await financeRepo.getFinanceData(userId);

      setState(() {
        _profile = profile;
        _finance = finance;
        _loadingHeader = false;
      });
    } catch (_) {
      setState(() => _loadingHeader = false);
    }
  }

  Widget _saldoPill(BuildContext context) {
    final balanceEK = _finance?.balance ?? 0.0;
    final reais = _finance == null ? 0.0 : (balanceEK * _finance!.ekToReal);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _loadingHeader
          ? const SizedBox(
              width: 80,
              height: 10,
              child: LinearProgressIndicator(),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${balanceEK.toStringAsFixed(2)} EcoKondo(s)',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                // const SizedBox(width: 8),
                // Text('•  ≈ R\$ ${reais.toStringAsFixed(2)}'),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final name = _profile?.fullName ?? 'Usuário';
    return AppBar(
      actions: [_saldoPill(context)],
      // titleSpacing: 8,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleMedium),
          // const SizedBox(height: 8),
          // _saldoPill(context),
        ],
      ),
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
      appBar: _buildAppBar(context),
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
