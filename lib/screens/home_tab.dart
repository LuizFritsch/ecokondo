
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/city.dart';
import '../models/exchange_point.dart';
import '../models/material_rule.dart';
import '../repositories/cities.dart';
import '../repositories/materials.dart';
import '../repositories/users.dart';
import '../utils/auth_utils.dart';
import '../theme/app_theme.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final UsersRepository usersRepo = UsersRepository();
  final CitiesRepository citiesRepo = CitiesRepository();
  final MaterialsRepository materialsRepo = MaterialsRepository();

  int? _userId;
  List<City> _cities = [];
  int? _selectedCityId;

  List<MaterialRule> _allowed = [];
  List<MaterialRule> _denied = [];
  List<ExchangePoint> _points = [];

  bool _loading = true;

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

      final prof = await usersRepo.getProfile(id);
      final cities = await citiesRepo.list();
      final mats = await materialsRepo.list();

      int? selectedId = prof.preferredCityId != 0 ? prof.preferredCityId : null;
      selectedId ??= cities.isNotEmpty ? cities.first.id : null;

      List<ExchangePoint> pts = [];
      if (selectedId != null) {
        pts = await citiesRepo.exchangePoints(selectedId);
      }

      setState(() {
        _cities = cities;
        _selectedCityId = selectedId;
        _allowed = mats.allowed;
        _denied = mats.denied;
        _points = pts;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _setCity(int newCityId) async {
    if (_userId == null) return;
    await usersRepo.setPreferredCity(_userId!, newCityId);
    final pts = await citiesRepo.exchangePoints(newCityId);
    setState(() {
      _selectedCityId = newCityId;
      _points = pts;
    });
  }

  Future<void> _openMap(ExchangePoint p) async {
    final google = Uri.parse('https://www.google.com/maps/search/?api=1&query=${p.latitude},${p.longitude}&query_place_id=${Uri.encodeComponent(p.name)}');
    final geo = Uri.parse('geo:${p.latitude},${p.longitude}?q=${p.latitude},${p.longitude}(${Uri.encodeComponent(p.name)})');
    try {
      if (await canLaunchUrl(google)) {
        await launchUrl(google, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}
    if (await canLaunchUrl(geo)) {
      await launchUrl(geo, mode: LaunchMode.externalApplication);
      return;
    }
    await launchUrl(google, mode: LaunchMode.platformDefault);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: _bootstrap,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Text('Ponto de troca:'),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _selectedCityId,
                  hint: const Text('Selecione'),
                  items: _cities.map((c) => DropdownMenuItem<int>(
                    value: c.id, child: Text('${c.name} - ${c.state}'))).toList(),
                  onChanged: (val) { if (val != null) _setCity(val); },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Pontos de troca', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_points.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.location_off),
                title: Text('Ainda não há pontos cadastrados para esta cidade.'),
              ),
            )
          else
            Column(
              children: _points.map((p) => Card(
                child: ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(p.name),
                  subtitle: Text(p.address),
                  onTap: () => _openMap(p),
                  trailing: const Icon(Icons.open_in_new),
                ),
              )).toList(),
            ),
          const SizedBox(height: 24),
          Text('Materiais que PODEM ser vendidos', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _MaterialsGrid(items: _allowed, allowed: true),
          const SizedBox(height: 24),
          Text('Materiais que NÃO PODEM ser vendidos', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _MaterialsGrid(items: _denied, allowed: false),
        ],
      ),
    );
  }
}

class _MaterialsGrid extends StatelessWidget {
  const _MaterialsGrid({required this.items, required this.allowed});
  final List<MaterialRule> items;
  final bool allowed;

  String _displayName(String key) {
    switch (key) {
      case 'plastico_mole': return 'Plástico mole';
      case 'papel_papelao': return 'Papel/Papelão';
      case 'oleo_cozinha':  return 'Óleo de cozinha';
      case 'caixa_leite':   return 'Caixa de leite';
      default:
        final pretty = key.replaceAll('_', ' ');
        return pretty.isEmpty ? key : pretty[0].toUpperCase() + pretty.substring(1);
    }
  }

  IconData _iconFor(String key) {
    switch (key) {
      case 'pet': return Icons.local_drink;
      case 'aluminio': return Icons.local_cafe;
      case 'vidro': return Icons.wine_bar;
      case 'papel_papelao': return Icons.description;
      case 'plastico_mole': return Icons.shopping_bag;
      case 'oleo_cozinha': return Icons.oil_barrel;
      case 'ferro': return Icons.build;
      case 'toner': return Icons.print_disabled;
      case 'tecidos': return Icons.dry_cleaning;
      case 'pneus': return Icons.tire_repair_sharp;
      case 'residuos_organicos': return Icons.eco;
      case 'madeira_tratada': return Icons.grass;
      case 'tintas_solventes': return Icons.format_paint;
      case 'eletronicos_baterias': return Icons.battery_alert;
      case 'caixa_leite': return Icons.local_mall;
      default: return allowed ? Icons.check_circle : Icons.block;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = allowed ? AppColors.success : AppColors.error;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.6,
      ),
      itemBuilder: (_, idx) {
        final it = items[idx];
        final icon = _iconFor(it.icon);
        final label = it.label == it.key ? _displayName(it.key) : it.label;
        return Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
