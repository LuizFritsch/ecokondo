import 'package:ecokondo/ecokondo.dart';
import 'package:flutter/material.dart';

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

  Widget _buildRankCard({
    required String label,
    required int rank,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                "#$rank",
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_stats == null)
      return const Center(child: Text('Erro ao carregar estatísticas.'));

    final recycledMaterials = [..._stats!.materialsRecycled]
      ..sort((a, b) => b.quantityKg.compareTo(a.quantityKg));

    // Valores de rank (mock enquanto backend não envia)
    final globalRank = _stats!.globalRank ?? 1;
    final cityRank = _stats!.cityRank ?? 1;
    final districtRank = _stats!.districtRank ?? 1;

    return RefreshIndicator(
      onRefresh: _bootstrap,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- NOVA SEÇÃO DE RANKING ---
          Text('Ranking', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRankCard(
                label: 'Global',
                rank: globalRank,
                icon: Icons.public,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _buildRankCard(
                label: 'Cidade',
                rank: cityRank,
                icon: Icons.location_city,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              _buildRankCard(
                label: 'Bairro',
                rank: districtRank,
                icon: Icons.home_work,
                color: Colors.teal,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- LISTA DE MATERIAIS RECICLADOS ---
          Text(
            'Materiais reciclados',
            style: Theme.of(context).textTheme.titleMedium,
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
    );
  }
}
