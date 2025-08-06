// File: lib/domain/entities/user_profile.dart
class UserProfile {
  final String id;
  final String name;
  final String username;
  final int age;
  final String location;
  final String profileImage;
  final bool isOnline;
  final bool isVerified;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.age,
    required this.location,
    required this.profileImage,
    this.isOnline = false,
    this.isVerified = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      age: json['age'] ?? 0,
      location: json['location'] ?? '',
      profileImage: json['profileImage'] ?? '',
      isOnline: json['isOnline'] ?? false,
      isVerified: json['isVerified'] ?? false,
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
    };
  }
}