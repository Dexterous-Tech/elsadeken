// user_model.dart
class UserModel {
  final int id; // Added ID field
  final String name;
  final int age;
  final String profession;
  final String country;
  final String city;
  final String imageUrl;
  final int matchPercentage;
  final bool isOnline;
  final bool isFavorite; // Added favorite status

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.profession,
    required this.city,
    required this.country,
    required this.imageUrl,
    required this.matchPercentage,
    this.isOnline = false,
    this.isFavorite = false,
  });
}
