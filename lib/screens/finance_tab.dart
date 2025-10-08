import 'package:flutter/material.dart';

import '../models/finance.dart';
import '../repositories/finance.dart';
import '../utils/auth_utils.dart';

class FinanceTab extends StatefulWidget {
  const FinanceTab({super.key});

  @override
  State<FinanceTab> createState() => _FinanceTabState();
}

class _FinanceTabState extends State<FinanceTab> {
  final FinanceRepository repo = FinanceRepository();

  int? _userId;
  FinanceData? _finance;
  bool _loading = true;

  String _displayName(String key) {
    switch (key) {
      case 'plastico_mole':
        return 'Plástico mole';
      case 'papel_papelao':
        return 'Papel/Papelão';
      case 'oleo_cozinha':
        return 'Óleo de cozinha';
      case 'caixa_leite':
        return 'Caixa de leite';
      default:
        final pretty = key.replaceAll('_', ' ');
        return pretty.isEmpty
            ? key
            : pretty[0].toUpperCase() + pretty.substring(1);
    }
  }

  IconData _iconFor(String key) {
    switch (key) {
      case 'pet':
        return Icons.local_drink;
      case 'aluminio':
        return Icons.local_cafe;
      case 'vidro':
        return Icons.wine_bar;
      case 'papel_papelao':
        return Icons.description;
      case 'plastico_mole':
        return Icons.shopping_bag;
      case 'oleo_cozinha':
        return Icons.oil_barrel;
      case 'ferro':
        return Icons.build;
      case 'jornal':
        return Icons.menu_book;
      case 'papelao':
        return Icons.inventory_2;
      case 'caixa_leite':
        return Icons.local_mall;
      default:
        return Icons.category;
    }
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final id = await getCurrentUserId();
      if (id == null) {
        setState(() => _loading = false);
        return;
      }
      _userId = id;

      final fin = await repo.getFinanceData(id);
      setState(() {
        _finance = fin;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _reload() async {
    if (_userId == null) return;
    final fin = await repo.getFinanceData(_userId!);
    setState(() => _finance = fin);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_finance == null)
      return const Center(child: Text('Erro ao carregar finanças'));

    final reais = _finance!.balance * _finance!.ekToReal;

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Quanto meu lixo vale?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._finance!.materials.entries.map(
            (e) => ListTile(
              leading: Icon(_iconFor(e.key)),
              title: Text(_displayName(e.key)),
              trailing: Text(e.value.toStringAsFixed(2)),
            ),
          ),
        ],
      ),
    );
  }
}
