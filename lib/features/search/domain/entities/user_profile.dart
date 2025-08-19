// File: lib/domain/entities/user_profile.dart
class UserProfile {
  final int id;
  final String name;
  final String username;
  final int age;
  final String location;
  final String profileImage;
  final bool isOnline;
  final bool isVerified;
  final String country;
  final String city;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.age,
    required this.location,
    required this.profileImage,
    this.isOnline = false,
    this.isVerified = false,
    this.country = '',
    this.city = '',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final attribute = json['attribute'];

    // Debug: Print the raw ID value and its type
    print('Raw ID from JSON: ${json['id']} (type: ${json['id'].runtimeType})');

    int parsedId;
    if (json['id'] is int) {
      parsedId = json['id'] as int;
    } else {
      parsedId = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    }

    print('Parsed ID: $parsedId (type: ${parsedId.runtimeType})');

    return UserProfile(
      id: parsedId,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      age: attribute != null && attribute['age'] != null
          ? attribute['age'] as int
          : 0,
      location: json['location'] ?? '',
      profileImage: json['image'] ?? '',
      isOnline: json['isOnline'] ?? false,
      isVerified: json['isVerified'] ?? false,
      country: attribute != null && attribute['country'] != null
          ? attribute['country']
          : '',
      city: attribute != null && attribute['city'] != null
          ? attribute['city']
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'age': age,
      'location': location,
      'profileImage': profileImage,
      'isOnline': isOnline,
      'isVerified': isVerified,
      'country': country,
      'city': city,
    };
  }
}
