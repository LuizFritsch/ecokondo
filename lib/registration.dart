import 'package:ecokondo/constants.dart';
import 'package:ecokondo/validators.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> _cities = [
    'Caxias do Sul',
    'Porto Alegre',
    'São Leopoldo',
    'Bento Gonçalves',
    'Novo Hamburgo',
  ];
  String? _selectedCity;
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simula o registro
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registro finalizado com sucesso...'),
      ),
    );

    Navigator.pop(context); // Volta para o login
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cadastrar),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.eco, color:  AppColors.primary, size: 80),
                const SizedBox(height: 8),
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 32),

                // E-mail
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: AppStrings.email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    labelText: AppStrings.senha,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),

                // Selecionar cidade
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_city_outlined),
                    labelText: 'Cidade',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _cities
                      .map(
                        (city) => DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    ),
                  )
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCity = value),
                  validator: Validators.city,
                ),
                const SizedBox(height: 24),

                // Botão de cadastro
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      AppStrings.cadastrar,
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
