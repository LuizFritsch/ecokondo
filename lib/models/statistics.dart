class MaterialStat {
  final String name;
  final double kg;
  final double ek;

  // Getter para manter compatibilidade com o front
  double get quantityKg => kg;

  MaterialStat({required this.name, required this.kg, required this.ek});

  factory MaterialStat.fromJson(Map<String, dynamic> json) {
    return MaterialStat(
      name: json['name'] ?? 'Desconhecido',
      kg: (json['kg'] as num?)?.toDouble() ?? 0.0,
      ek: (json['ek'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'kg': kg, 'ek': ek};
}

class SaleMaterialItem {
  final String name;
  final double quantity;
  final double ekReceived;

  // Getter compatível com telas antigas
  double get quantityKg => quantity;

  SaleMaterialItem({
    required this.name,
    required this.quantity,
    required this.ekReceived,
  });

  factory SaleMaterialItem.fromJson(Map<String, dynamic> json) {
    return SaleMaterialItem(
      name: json['name'] ?? 'Desconhecido',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      ekReceived: (json['ek_received'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'ek_received': ekReceived,
  };
}

class SalesHistory {
  final int id;
  final DateTime date;
  final String cityName;
  final String state;
  final List<SaleMaterialItem> materials;
  final double totalEk;

  SalesHistory({
    required this.id,
    required this.date,
    required this.cityName,
    required this.state,
    required this.materials,
    required this.totalEk,
  });

  factory SalesHistory.fromJson(Map<String, dynamic> json) {
    final city = json['city'] ?? {};
    return SalesHistory(
      id: json['id'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      cityName: city['name'] ?? '',
      state: city['state'] ?? '',
      materials: (json['materials'] as List<dynamic>? ?? [])
          .map((e) => SaleMaterialItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      totalEk: (json['total_ek'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'city': {'name': cityName, 'state': state},
    'materials': materials.map((e) => e.toJson()).toList(),
    'total_ek': totalEk,
  };
}

class UserStatistics {
  final List<MaterialStat> materialsRecycled;
  final List<SalesHistory> salesHistory;

  // Campos opcionais de ranking
  final int? globalRank;
  final int? cityRank;
  final int? districtRank;

  UserStatistics({
    required this.materialsRecycled,
    required this.salesHistory,
    this.globalRank,
    this.cityRank,
    this.districtRank,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    final recycled = json['recycled'] ?? {};
    final byMaterial = recycled['by_material'] as List<dynamic>? ?? [];
    final sales = json['sales_history'] as List<dynamic>? ?? [];

    return UserStatistics(
      materialsRecycled: byMaterial
          .map((e) => MaterialStat.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      salesHistory: sales
          .map((e) => SalesHistory.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      globalRank: json['globalRank'] is int ? json['globalRank'] : null,
      cityRank: json['cityRank'] is int ? json['cityRank'] : null,
      districtRank: json['districtRank'] is int ? json['districtRank'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'materialsRecycled': materialsRecycled.map((e) => e.toJson()).toList(),
    'salesHistory': salesHistory.map((e) => e.toJson()).toList(),
    if (globalRank != null) 'globalRank': globalRank,
    if (cityRank != null) 'cityRank': cityRank,
    if (districtRank != null) 'districtRank': districtRank,
  };
}
