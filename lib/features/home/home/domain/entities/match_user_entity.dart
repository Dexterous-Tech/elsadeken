// match_user_entity.dart
class MatchUserEntity {
  final String id;
  final String name;
  final String imageUrl;
  final int age;
  final String profession;
  final String location;
  final int matchPercentage;
  final bool isFavorite;

  MatchUserEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.age,
    required this.profession,
    required this.location,
    required this.matchPercentage,
    required this.isFavorite,
  });
}