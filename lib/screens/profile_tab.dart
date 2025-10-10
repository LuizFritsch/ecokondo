import 'package:ecokondo/ecokondo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final UsersRepository usersRepo = UsersRepository();

  int? _userId;
  UserProfile? _profile;
  bool _loading = true;

  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final neighCtrl = TextEditingController();
  final postalCtrl = TextEditingController();
  final complCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final id = await getCurrentUserId();
    if (id == null) {
      setState(() => _loading = false);
      return;
    }
    _userId = id;
    final prof = await usersRepo.getProfile(id);
    nameCtrl.text = prof.fullName;
    streetCtrl.text = prof.address.street;
    numberCtrl.text = prof.address.number;
    neighCtrl.text = prof.address.neighborhood;
    postalCtrl.text = prof.address.postalCode ?? '';
    complCtrl.text = prof.address.complement ?? '';
    setState(() {
      _profile = prof;
      _loading = false;
    });
  }

  InputDecoration _dec(String label, IconData icon) =>
      InputDecoration(labelText: label, prefixIcon: Icon(icon));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _userId == null) return;
    final updated = await usersRepo.updateProfile(_userId!, {
      'fullName': nameCtrl.text,
      'address': {
        'street': streetCtrl.text,
        'number': numberCtrl.text,
        'neighborhood': neighCtrl.text,
        'postalCode': postalCtrl.text,
        'complement': complCtrl.text,
      },
    });
    setState(() => _profile = updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> _confirmLogout() async {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Sair da conta?'),
          content: const Text(
            'Você tem certeza que deseja encerrar sua sessão?',
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
            ),
          ],
        ),
      );

      if (ok == true) {
        await logout();
        if (!mounted) return;

        // ✅ volta para a tela de login
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout realizado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_profile == null)
      return const Center(child: Text('Não foi possível carregar seu perfil.'));

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.12),
                    child: Text(
                      (_profile!.fullName.isNotEmpty
                              ? _profile!.fullName[0]
                              : 'U')
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _profile!.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Dados pessoais',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: _dec('Nome completo', Icons.person),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Informe seu nome'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Endereço', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextFormField(
                      controller: streetCtrl,
                      decoration: _dec('Rua', Icons.location_on),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: numberCtrl,
                            decoration: _dec('Número', Icons.tag),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: neighCtrl,
                            decoration: _dec('Bairro', Icons.map),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: postalCtrl,
                            decoration: _dec('CEP', Icons.markunread_mailbox),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: complCtrl,
                            decoration: _dec(
                              'Complemento',
                              Icons.note_alt_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar alterações'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _confirmLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
