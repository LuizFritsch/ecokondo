class MaterialRule {
  final String key; // usado p/ mapear ícone
  final String label; // texto exibido
  final bool allowed; // true/false
  final String icon; // mesma da key, por clareza

  MaterialRule({
    required this.key,
    required this.label,
    required this.allowed,
    required this.icon,
  });

  factory MaterialRule.fromJson(Map<String, dynamic> json) => MaterialRule(
    key: json['key'] as String,
    label: json['label'] as String,
    allowed: json['allowed'] as bool,
    icon: json['icon'] as String? ?? json['key'] as String,
  );
}

class MaterialsResponse {
  final List<MaterialRule> allowed;
  final List<MaterialRule> denied;

  MaterialsResponse({required this.allowed, required this.denied});

  factory MaterialsResponse.fromJson(Map<String, dynamic> json) =>
      MaterialsResponse(
        allowed: (json['allowed'] as List<dynamic>)
            .map((e) => MaterialRule.fromJson(e as Map<String, dynamic>))
            .toList(),
        denied: (json['denied'] as List<dynamic>)
            .map((e) => MaterialRule.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
