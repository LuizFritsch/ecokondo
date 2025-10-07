class AuthPayload {
  final int sub; // geralmente é o ID do usuário
  final String username;
  final String userType;
  final int iat; // issued at (timestamp)
  final int exp; // expiration time (timestamp)

  AuthPayload({
    required this.sub,
    required this.username,
    required this.userType,
    required this.iat,
    required this.exp,
  });

  /// Cria um objeto a partir de um JSON (map)
  factory AuthPayload.fromJson(Map<String, dynamic> json) {
    return AuthPayload(
      sub: json['sub'] as int,
      username: json['username'] as String,
      userType: json['userType'] as String,
      iat: json['iat'] as int,
      exp: json['exp'] as int,
    );
  }

  /// Converte o objeto para JSON (caso precise enviar)
  Map<String, dynamic> toJson() => {
    'sub': sub,
    'username': username,
    'userType': userType,
    'iat': iat,
    'exp': exp,
  };

  /// Calcula quanto tempo falta até expirar (em segundos)
  Duration get timeToExpire =>
      Duration(seconds: exp - DateTime.now().millisecondsSinceEpoch ~/ 1000);

  /// Retorna true se o token ainda for válido
  bool get isValid => DateTime.now().millisecondsSinceEpoch ~/ 1000 < exp;
}
