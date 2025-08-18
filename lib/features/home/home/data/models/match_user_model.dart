import 'package:elsadeken/features/home/home/domain/entities/match_user_entity.dart';

class MatchUserModel {
  final int id;
  final String name;
  final String image;
  final int age;
  final String gender;
  final String nationality;
  final String country;
  final String city;
  final String job;
  final int matchPercentage;
  final bool isFavorite;

  MatchUserModel({
    required this.id,
    required this.name,
    required this.image,
    required this.age,
    required this.gender,
    required this.nationality,
    required this.country,
    required this.city,
    required this.job,
    required this.matchPercentage,
    required this.isFavorite,
  });

  factory MatchUserModel.fromJson(Map<String, dynamic> json) {
    return MatchUserModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      age: json['age'],
      gender: json['gender'],
      nationality: json['nationality'],
      country: json['country'],
      city: json['city'],
      job: json['job'],
      matchPercentage: json['match_percentage'],
      isFavorite: json['is_favorite'] == 1,
    );
  }

  // Convert to entity
  MatchUserEntity toEntity() {
    return MatchUserEntity(
      id: id.toString(),
      name: name,
      imageUrl: image,
      age: age,
      profession: job,
      location: '$city, $country',
      matchPercentage: matchPercentage,
      isFavorite: isFavorite,
    );
  }
}