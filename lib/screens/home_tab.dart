import 'package:ecokondo/ecokondo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FinanceRepository financeRepo = FinanceRepository();
  final UsersRepository usersRepo = UsersRepository();
  final CitiesRepository citiesRepo = CitiesRepository();
  final MaterialsRepository materialsRepo = MaterialsRepository();

  int? _userId;
  UserProfile? _profile;
  List<City> _cities = [];
  FinanceData? _finance;
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

      FinanceData? fin;
      List<ExchangePoint> pts = [];
      if (_userId != null) {
        fin = await financeRepo.getFinanceData(_userId!);
      }
      if (selectedId != null) {
        pts = await citiesRepo.exchangePoints(selectedId);
      }

      setState(() {
        _profile = prof;
        _cities = cities;
        _finance = fin;
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
    final newId = await usersRepo.setPreferredCity(_userId!, newCityId);
    final fin = await financeRepo.getFinanceData(_userId!);
    final pts = await citiesRepo.exchangePoints(newId);

    setState(() {
      _profile = UserProfile(
        userId: _profile!.userId,
        fullName: _profile!.fullName,
        userType: _profile!.userType,
        address: _profile!.address,
        preferredCityId: newId,
      );
      _finance = fin;
      _selectedCityId = newId;
      _points = pts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_profile == null)
      return const Center(child: Text('Não foi possível carregar seu perfil.'));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _bootstrap,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Olá, ${_profile!.fullName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'Veja seu saldo e pontos de troca na sua cidade',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (_finance != null) _BalanceCard(finance: _finance!),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text('Cidade de venda:'),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _selectedCityId,
                    hint: const Text('Selecione'),
                    items: _cities
                        .map(
                          (c) => DropdownMenuItem<int>(
                            value: c.id,
                            child: Text('${c.name} - ${c.state}'),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) _setCity(val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Pontos de troca',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _ExchangePointsList(points: _points),

            const SizedBox(height: 24),
            Text(
              'Materiais que PODEM ser vendidos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _MaterialsGrid(items: _allowed, allowed: true),

            const SizedBox(height: 24),
            Text(
              'Materiais que NÃO PODEM ser vendidos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _MaterialsGrid(items: _denied, allowed: false),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.finance});

  final FinanceData finance;

  @override
  Widget build(BuildContext context) {
    final reais = finance.balance * finance.ekToReal;
    return Card(
      child: ListTile(
        title: Text('Saldo: ${finance.balance.toStringAsFixed(2)} EK'),
        subtitle: Text('≈ R\$ ${reais.toStringAsFixed(2)}'),
      ),
    );
  }
}

class _ExchangePointsList extends StatelessWidget {
  const _ExchangePointsList({required this.points});

  final List<ExchangePoint> points;

  Future<void> _openMap(ExchangePoint p) async {
    // link universal do Google Maps (abre app ou navegador)
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${p.latitude},${p.longitude}&query_place_id=${Uri.encodeComponent(p.name)}',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // fallback (abre no navegador)
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.location_off),
          title: Text('Ainda não há pontos cadastrados para esta cidade.'),
        ),
      );
    }

    return Column(
      children: points
          .map(
            (p) => Card(
              child: ListTile(
                leading: const Icon(Icons.place),
                title: Text(p.name),
                // removi as coordenadas da UI — só o endereço
                subtitle: Text(p.address),
                isThreeLine: false,
                onTap: () {
                  debugPrint('[HOME][PONTO_DE_TROCA] Pressed');
                  _openMap(p);
                },
                trailing: const Icon(Icons.open_in_new),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MaterialsGrid extends StatelessWidget {
  const _MaterialsGrid({required this.items, required this.allowed});

  final List<MaterialRule> items;
  final bool allowed;

  IconData _iconFor(String key, bool allowed) {
    // mapeia chave do backend para ícones específicos
    switch (key) {
      case 'pet':
        return Icons.local_drink; // garrafa PET
      case 'aluminio':
        return Icons.local_cafe; // lata
      case 'papel_papelao':
        return Icons.description; // papel
      case 'vidro':
        return Icons.wine_bar; // vidro
      case 'plastico_mole':
        return Icons.shopping_bag; // saco/plástico
      case 'oleo_cozinha':
        return Icons.oil_barrel;
      case 'ferro':
        return Icons.build;

      case 'toner':
        return Icons.print_disabled;
      case 'tecidos':
        return Icons.dry_cleaning;
      case 'pneus':
        return Icons.tire_repair_sharp; // pneu abstrato
      case 'residuos_organicos':
        return Icons.eco;
      case 'madeira_tratada':
        return Icons.grass; // aproximado
      case 'tintas_solventes':
        return Icons.format_paint;
      case 'eletronicos_baterias':
        return Icons.battery_alert;
    }
    // fallback
    return allowed ? Icons.check_circle : Icons.block;
  }

  @override
  Widget build(BuildContext context) {
    final color = allowed ? Colors.green[600]! : Colors.red[600]!;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.6,
      ),
      itemBuilder: (_, idx) {
        final it = items[idx];
        final icon = _iconFor(it.icon, allowed);
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
                  it.label,
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
