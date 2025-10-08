import 'package:ecokondo/ecokondo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsTab extends StatefulWidget {
  const StatisticsTab({super.key});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  final repo = StatisticsRepository();
  UserStatistics? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    final stats = await repo.getUserStatistics();
    setState(() {
      _stats = stats;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_stats == null)
      return const Center(child: Text("Erro ao carregar estatísticas."));

    // Ordena materiais reciclados do maior para o menor
    final recycledMaterials = [..._stats!.materialsRecycled];
    recycledMaterials.sort((a, b) => b.quantityKg.compareTo(a.quantityKg));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== Materiais Reciclados ======
          const Text(
            "Materiais Reciclados",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Column(
            children: recycledMaterials.map((material) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(material.name[0].toUpperCase()),
                    backgroundColor: Colors.green[200],
                  ),
                  title: Text(
                    material.name[0].toUpperCase() + material.name.substring(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "${material.quantityKg} kg",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // ====== Histórico de Vendas ======
          const Text(
            "Histórico de Vendas",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Column(
            children: _stats!.salesHistory.map((sale) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    "Venda em ${DateFormat('dd/MM/yyyy').format(sale.date)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Total EcoKondos: ${sale.totalEk}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  children: sale.materials.map((item) {
                    return ListTile(
                      leading: const Icon(Icons.recycling, color: Colors.green),
                      title: Text(
                        item.name[0].toUpperCase() + item.name.substring(1),
                      ),
                      subtitle: Text("${item.quantityKg} kg"),
                      trailing: Text("${item.ekReceived} EK"),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
