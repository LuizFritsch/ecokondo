class PurchaseItem {
  final String name;
  final double valueEk;

  PurchaseItem({required this.name, required this.valueEk});

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      name: json['name'] ?? 'Desconhecido',
      valueEk: (json['value_ek'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'value_ek': valueEk};
}

class Purchase {
  final int id;
  final DateTime date;
  final String merchant;
  final double totalEk;
  final List<PurchaseItem> items;

  Purchase({
    required this.id,
    required this.date,
    required this.merchant,
    required this.totalEk,
    required this.items,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return Purchase(
      id: json['id'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      merchant: json['merchant'] ?? 'Desconhecido',
      totalEk: (json['total_ek'] as num?)?.toDouble() ?? 0.0,
      items: itemsJson.map((e) => PurchaseItem.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'merchant': merchant,
    'total_ek': totalEk,
    'items': items.map((e) => e.toJson()).toList(),
  };
}
