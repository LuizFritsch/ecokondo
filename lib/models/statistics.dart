class UserStatistics {
  final List<RecycledMaterial> materialsRecycled;
  final List<Sale> salesHistory;

  UserStatistics({required this.materialsRecycled, required this.salesHistory});

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    // Ajuste os nomes de acordo com o JSON do backend
    final recycledList = json['recycled'] as List<dynamic>? ?? [];
    final salesList = json['sales_history'] as List<dynamic>? ?? [];

    return UserStatistics(
      materialsRecycled: recycledList
          .map((e) => RecycledMaterial.fromJson(e as Map<String, dynamic>))
          .toList(),
      salesHistory: salesList
          .map((sale) => Sale.fromJson(sale as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RecycledMaterial {
  final String name;
  final double quantityKg;

  RecycledMaterial({required this.name, required this.quantityKg});

  factory RecycledMaterial.fromJson(Map<String, dynamic> json) {
    return RecycledMaterial(
      name: json['name'] ?? '',
      quantityKg: (json['quantity'] ?? 0).toDouble(),
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

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      name: json['name'] ?? '',
      quantityKg: (json['quantity'] ?? 0).toDouble(),
      ekReceived: (json['ek_received'] ?? 0).toDouble(),
    );
  }
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
      date: DateTime.parse(json['date']),
      materials: materialsList
          .map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalEk: (json['total_ek'] ?? 0).toDouble(),
    );
  }
}
