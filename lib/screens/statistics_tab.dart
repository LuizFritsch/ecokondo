import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/city.dart';
import '../models/statistics.dart';
import '../models/user_profile.dart';
import '../repositories/cities.dart';
import '../repositories/statistics.dart';
import '../repositories/users.dart';
import '../utils/auth_utils.dart';

class StatisticsTab extends StatefulWidget {
  const StatisticsTab({super.key});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  final StatisticsRepository repo = StatisticsRepository();
  final UsersRepository usersRepo = UsersRepository();
  final CitiesRepository citiesRepo = CitiesRepository();

  int? _userId;
  UserProfile? _profile;
  List<City> _cities = [];
  UserStatistics? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final id = await getCurrentUserId();
    if (id == null) return;
    _userId = id;
    try {
      final prof = await usersRepo.getProfile(id);
      final cities = await citiesRepo.list();
      final stats = await repo.getStatistics(id);
      setState(() {
        _profile = prof;
        _cities = cities;
        _stats = stats;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _reloadStats() async {
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_profile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Cidade de venda:'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: _profile!.preferredCityId == 0
                          ? null
                          : _profile!.preferredCityId,
                      hint: const Text('Selecione'),
                      items: _cities
                          .map(
                            (c) => DropdownMenuItem<int>(
                              value: c.id,
                              child: Text("${c.name} - ${c.state}"),
                            ),
                          )
                          .toList(),
                      onChanged: (val) async {
                        if (val == null || _userId == null) return;
                        final newId = await usersRepo.setPreferredCity(
                          _userId!,
                          val,
                        );
                        setState(() {
                          _profile = UserProfile(
                            userId: _profile!.userId,
                            fullName: _profile!.fullName,
                            userType: _profile!.userType,
                            address: _profile!.address,
                            preferredCityId: newId,
                          );
                        });
                        await _reloadStats();
                      },
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Materiais reciclados',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...recycledMaterials.map(
            (m) => ListTile(
              title: Text(m.name),
              trailing: Text("${m.quantityKg.toStringAsFixed(1)} kg"),
            ),
          ),
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
                          "${i.name}: ${i.quantityKg} kg → ${i.ekReceived} EK",
                        ),
                      )
                      .toList(),
                ),
                trailing: Text("${s.totalEk} EK"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
