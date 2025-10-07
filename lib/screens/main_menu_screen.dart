import 'package:ecokondo/ecokondo.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatefulWidget {
  final UserType userType;

  const MainMenuScreen({super.key, required this.userType});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _currentIndex = 0;

  // Mapa com tabs específicas para cada tipo de usuário
  late final Map<UserType, List<Widget>> _tabs;
  late final Map<UserType, List<BottomNavigationBarItem>> _navItems;
  late final Map<UserType, List<String>> _titles;

  @override
  void initState() {
    super.initState();
    _initMenus();
  }

  void _initMenus() {
    // telas padrão
    final commonTabs = const [
      HomeTab(),
      FinanceTab(),
      StatisticsTab(),
      ProfileTab(),
    ];

    final commonNav = const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(
        icon: Icon(Icons.attach_money),
        label: 'Financeiro',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        label: 'Estatísticas',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
    ];

    // aqui você pode personalizar futuramente por tipo
    _tabs = {
      UserType.prefeitura: commonTabs,
      UserType.usuario: commonTabs,
      UserType.admin: commonTabs,
    };

    _navItems = {
      UserType.prefeitura: commonNav,
      UserType.usuario: commonNav,
      UserType.admin: commonNav,
    };

    final commonTitles = ['Home', 'Financeiro', 'Estatísticas', 'Perfil'];

    _titles = {
      UserType.prefeitura: commonTitles,
      UserType.usuario: commonTitles,
      UserType.admin: commonTitles,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs[widget.userType]!;
    final navItems = _navItems[widget.userType]!;
    final titles = _titles[widget.userType]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final auth = AuthRepository();
              await auth.logout();

              // Volta para a tela de login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: navItems,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
