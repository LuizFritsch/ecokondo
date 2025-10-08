class ExchangePoint {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  ExchangePoint({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory ExchangePoint.fromJson(Map<String, dynamic> json) => ExchangePoint(
    name: json['name'] as String? ?? '',
    address: json['address'] as String? ?? '',
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
}
