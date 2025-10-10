
class City {
  final int id;
  final String name;
  final String state;
  final double latitude;
  final double longitude;

  City({
    required this.id,
    required this.name,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json['id'] as int,
        name: json['name'] as String,
        state: json['state'] as String? ?? '',
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );
}
