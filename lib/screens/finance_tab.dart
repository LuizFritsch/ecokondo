import 'package:ecokondo/ecokondo.dart';
import 'package:flutter/material.dart';

class FinanceTab extends StatefulWidget {
  const FinanceTab({super.key});

  @override
  State<FinanceTab> createState() => _FinanceTabState();
}

class _FinanceTabState extends State<FinanceTab> {
  final FinanceRepository repo = FinanceRepository();
  FinanceData? finance;

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  Future<void> _loadFinanceData() async {
    try {
      final data = await repo.getFinanceData();

      setState(() {
        finance = data;
      });
    } catch (e) {
      debugPrint('Erro ao carregar financeiro: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (finance == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final reais = finance!.balance * finance!.ekToReal;

    return RefreshIndicator(
      onRefresh: _loadFinanceData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Meu Saldo',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '${finance!.balance.toStringAsFixed(2)} EcoKondos',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    '≈ R\$ ${reais.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Conversão Atual',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '1 EcoKondo = R\$ ${finance!.ekToReal.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tabela de Materiais',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...finance!.materials.entries.map(
            (e) => ListTile(
              leading: const Icon(Icons.recycling, color: Colors.green),
              title: Text(e.key.replaceAll('_', ' ').toUpperCase()),
              trailing: Text('${e.value} EK / kg'),
            ),
          ),
        ],
      ),
    );
  }
}
