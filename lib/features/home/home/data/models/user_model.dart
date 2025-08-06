class UserModel {
  final String name;
  final int age;
  final String profession;
  final String location;
  final String imageUrl;
  final int matchPercentage;
  final bool isOnline;

  UserModel({
    required this.name,
    required this.age,
    required this.profession,
    required this.location,
    required this.imageUrl,
    required this.matchPercentage,
    this.isOnline = false,
  });
}