import 'package:flutter/material.dart';

import '../models/statistics.dart';
import '../repositories/statistics.dart';
import '../utils/auth_utils.dart';

class StatisticsTab extends StatefulWidget {
  const StatisticsTab({super.key});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  final StatisticsRepository repo = StatisticsRepository();

  int? _userId;
  UserStatistics? _stats;
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

      final stats = await repo.getStatistics(id);
      setState(() {
        _stats = stats;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _reload() async {
    if (_userId == null) return;
    final s = await repo.getStatistics(_userId!);
    setState(() => _stats = s);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_stats == null)
      return const Center(child: Text('Erro ao carregar estatísticas.'));

    final recycledMaterials = [..._stats!.materialsRecycled]
      ..sort((a, b) => b.quantityKg.compareTo(a.quantityKg));

    return RefreshIndicator(
      onRefresh: _reload,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Materiais reciclados',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...recycledMaterials.map(
              (m) => ListTile(
                leading: Icon(_iconFor(m.name)),
                title: Text(_displayName(m.name)),
                trailing: Text('${m.quantityKg.toStringAsFixed(1)} kg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
