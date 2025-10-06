class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite seu e-mail';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? city(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selecione uma cidade';
    }
    return null;
  }
}
