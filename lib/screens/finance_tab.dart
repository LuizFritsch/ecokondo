import 'package:ecokondo/ecokondo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinanceTab extends StatefulWidget {
  const FinanceTab({super.key});

  @override
  State<FinanceTab> createState() => _FinanceTabState();
}

class _FinanceTabState extends State<FinanceTab> {
  final FinanceRepository financeRepo = FinanceRepository();
  final StatisticsRepository statsRepo = StatisticsRepository();

  int? _userId;
  FinanceData? _finance;
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

      final finance = await financeRepo.getFinanceData(id);
      final stats = await statsRepo.getStatistics(id);

      setState(() {
        _finance = finance;
        _stats = stats;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_finance == null)
      return const Center(child: Text('Erro ao carregar finanças.'));

    final reais = _finance!.balance * _finance!.ekToReal;

    return RefreshIndicator(
      onRefresh: _bootstrap,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'Saldo: ${_finance!.balance.toStringAsFixed(2)} EcoKondo(s)',
              ),
              subtitle: Text('≈ R\$ ${reais.toStringAsFixed(2)}'),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Quanto vale meu lixo? (EK por kg)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._finance!.materials.entries.map(
            (e) => ListTile(
              leading: Icon(_iconFor(e.key)),
              title: Text(_displayName(e.key)),
              trailing: Text('${e.value.toStringAsFixed(2)} EK'),
            ),
          ),
          if (_stats?.salesHistory != null &&
              _stats!.salesHistory.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Histórico de vendas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._stats!.salesHistory.map(
              (s) => Card(
                child: ListTile(
                  title: Text(DateFormat('dd/MM/yyyy HH:mm').format(s.date)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: s.materials
                        .map(
                          (i) => Text(
                            '${_displayName(i.name)}: ${i.quantityKg} kg → ${i.ekReceived} EK',
                          ),
                        )
                        .toList(),
                  ),
                  trailing: Text(
                    '+${s.totalEk.toStringAsFixed(2)} EK',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FutureBuilder<List<Purchase>>(
              future: _userId != null
                  ? financeRepo.getPurchases(_userId!)
                  : Future.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text('Erro ao carregar histórico de compras.');
                }
                final purchases = snapshot.data ?? [];
                if (purchases.isEmpty) {
                  return const Text('Nenhuma compra registrada ainda.');
                }

                final isDark = Theme.of(context).brightness == Brightness.dark;
                final cardColor =
                    Theme.of(context).cardTheme.color ??
                    (isDark ? const Color(0xFF1E1E1E) : Colors.white);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Histórico de compras',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...purchases.map(
                      (p) => Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy HH:mm',
                                    ).format(p.date),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '-${p.totalEk.toStringAsFixed(2)} EKs',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.storefront,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      p.merchant,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...p.items.map(
                                (item) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.name),
                                    Text(
                                      '${item.valueEk.toStringAsFixed(2)} EK',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
