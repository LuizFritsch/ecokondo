import 'package:flutter/material.dart';

import '../models/city.dart';
import '../models/finance.dart';
import '../models/user_profile.dart';
import '../repositories/cities.dart';
import '../repositories/finance.dart';
import '../repositories/users.dart';
import '../utils/auth_utils.dart';

class FinanceTab extends StatefulWidget {
  const FinanceTab({super.key});

  @override
  State<FinanceTab> createState() => _FinanceTabState();
}

class _FinanceTabState extends State<FinanceTab> {
  final FinanceRepository repo = FinanceRepository();
  final UsersRepository usersRepo = UsersRepository();
  final CitiesRepository citiesRepo = CitiesRepository();

  int? _userId;
  UserProfile? _profile;
  List<City> _cities = [];
  FinanceData? _finance;
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
      final fin = await repo.getFinanceData(id);
      setState(() {
        _profile = prof;
        _cities = cities;
        _finance = fin;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _reloadFinance() async {
    if (_userId == null) return;
    final fin = await repo.getFinanceData(_userId!);
    setState(() => _finance = fin);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_finance == null) {
      return const Center(child: Text('Erro ao carregar finanças'));
    }
    final reais = _finance!.balance * _finance!.ekToReal;

    return RefreshIndicator(
      onRefresh: _reloadFinance,
      child: ListView(
        padding: const EdgeInsets.all(16),
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
                        await _reloadFinance();
                      },
                    ),
                  ),
                ],
              ),
            ),
          Card(
            child: ListTile(
              title: Text('Saldo: ${_finance!.balance.toStringAsFixed(2)} EK'),
              subtitle: Text('≈ R\$ ${reais.toStringAsFixed(2)}'),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Materiais (EK por kg)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._finance!.materials.entries.map(
            (e) => ListTile(
              title: Text(e.key),
              trailing: Text(e.value.toStringAsFixed(2)),
            ),
          ),
        ],
      ),
    );
  }
}
