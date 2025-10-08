
class Address {
  final String street;
  final String number;
  final String neighborhood;
  final int cityId;
  final String? postalCode;
  final String? complement;
  final double? latitude;
  final double? longitude;

  Address({
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.cityId,
    this.postalCode,
    this.complement,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json['street'] as String? ?? '',
        number: json['number'] as String? ?? '',
        neighborhood: json['neighborhood'] as String? ?? '',
        cityId: json['cityId'] as int? ?? 0,
        postalCode: json['postalCode'] as String?,
        complement: json['complement'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );
}
