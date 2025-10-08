
import 'address.dart';

class UserProfile {
  final int userId;
  final String fullName;
  final int userType;
  final Address address;
  final int preferredCityId;

  UserProfile({
    required this.userId,
    required this.fullName,
    required this.userType,
    required this.address,
    required this.preferredCityId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json['userId'] as int,
        fullName: json['fullName'] as String? ?? '',
        userType: json['userType'] as int? ?? 0,
        address: Address.fromJson(json['address'] as Map<String, dynamic>),
        preferredCityId: json['preferredCityId'] as int? ?? 0,
      );
}
