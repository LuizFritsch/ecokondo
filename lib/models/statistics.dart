
class UserStatistics {
  final List<RecycledMaterial> materialsRecycled;
  final List<Sale> salesHistory;

  UserStatistics({
    required this.materialsRecycled,
    required this.salesHistory,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    // Backend: { user: {...}, recycled: { total_kg, total_ek, by_material: [...] }, sales_history: [...] }
    final recycledObj = (json['recycled'] as Map<String, dynamic>?) ?? {};
    final byMaterial = (recycledObj['by_material'] as List<dynamic>? ?? [])
        .map((e) => RecycledMaterial.fromJson(e as Map<String, dynamic>))
        .toList();

    final salesList = (json['sales_history'] as List<dynamic>? ?? [])
        .map((e) => Sale.fromJson(e as Map<String, dynamic>))
        .toList();

    return UserStatistics(
      materialsRecycled: byMaterial,
      salesHistory: salesList,
    );
  }
}

class RecycledMaterial {
  final String name;
  final double quantityKg;
  final double? ek;

  RecycledMaterial({
    required this.name,
    required this.quantityKg,
    this.ek,
  });

  factory RecycledMaterial.fromJson(Map<String, dynamic> json) => RecycledMaterial(
        name: json['name'] as String? ?? '',
        quantityKg: (json['kg'] ?? json['quantity'] ?? 0).toDouble(),
        ek: (json['ek'] as num?)?.toDouble(),
      );
}

class Sale {
  final int id;
  final DateTime date;
  final List<SaleItem> materials;
  final double totalEk;

  Sale({
    required this.id,
    required this.date,
    required this.materials,
    required this.totalEk,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    final materialsList = json['materials'] as List<dynamic>? ?? [];
    return Sale(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date'] as String),
      materials: materialsList
          .map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalEk: (json['total_ek'] ?? 0).toDouble(),
    );
  }
}

class SaleItem {
  final String name;
  final double quantityKg;
  final double ekReceived;

  SaleItem({
    required this.name,
    required this.quantityKg,
    required this.ekReceived,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) => SaleItem(
        name: json['name'] as String? ?? '',
        quantityKg: (json['quantity'] ?? json['kg'] ?? 0).toDouble(),
        ekReceived: (json['ek_received'] ?? json['ek'] ?? 0).toDouble(),
      );
}
