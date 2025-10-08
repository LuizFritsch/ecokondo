class FinanceData {
  final double balance;
  final double ekToReal;
  final Map<String, double> materials;

  FinanceData({
    required this.balance,
    required this.ekToReal,
    required this.materials,
  });

  factory FinanceData.fromJson(Map<String, dynamic> json) {
    return FinanceData(
      balance: (json['balance'] ?? 0).toDouble(),
      ekToReal: (json['ek_to_real'] ?? 1).toDouble(),
      materials: (json['materials'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value ?? 0).toDouble()),
      ),
    );
  }
}
