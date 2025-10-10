
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../repositories/users.dart';
import '../utils/auth_utils.dart';
import '../theme/app_theme.dart';

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
    setState(() { _profile = prof; _loading = false; });
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
  );

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
      }
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

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_profile == null) return const Center(child: Text('Não foi possível carregar seu perfil.'));

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
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withOpacity(0.12),
                    child: Text(
                      (_profile!.fullName.isNotEmpty ? _profile!.fullName[0] : 'U').toUpperCase(),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
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
            Text('Dados pessoais', style: Theme.of(context).textTheme.titleMedium),
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
                        validator: (v) => (v == null || v.isEmpty) ? 'Informe seu nome' : null,
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
                    TextFormField(controller: streetCtrl, decoration: _dec('Rua', Icons.location_on)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TextFormField(controller: numberCtrl, decoration: _dec('Número', Icons.tag))),
                        const SizedBox(width: 12),
                        Expanded(child: TextFormField(controller: neighCtrl, decoration: _dec('Bairro', Icons.map))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TextFormField(controller: postalCtrl, decoration: _dec('CEP', Icons.markunread_mailbox))),
                        const SizedBox(width: 12),
                        Expanded(child: TextFormField(controller: complCtrl, decoration: _dec('Complemento', Icons.note_alt_outlined))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 16, right: 16, bottom: 16,
          child: SafeArea(
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Salvar alterações'),
            ),
          ),
        ),
      ],
    );
  }
}
