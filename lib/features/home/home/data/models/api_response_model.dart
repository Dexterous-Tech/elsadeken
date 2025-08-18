// api_user_model.dart
import 'package:elsadeken/features/home/home/data/models/user_model.dart';

class ApiUserModel {
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

  ApiUserModel({
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

  factory ApiUserModel.fromJson(Map<String, dynamic> json) {
    return ApiUserModel(
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

  UserModel toUserModel() {
    return UserModel(
      id: id.toString(),
      name: name,
      age: age,
      profession: job,
      location: '$city, $country',
      imageUrl: image,
      matchPercentage: matchPercentage,
      isFavorite: isFavorite,
    );
  }
}

class MatchesResponse {
  final List<ApiUserModel> data;
  final PaginationLinks links;
  final PaginationMeta meta;

  MatchesResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory MatchesResponse.fromJson(Map<String, dynamic> json) {
    return MatchesResponse(
      data: (json['data'] as List)
          .map((i) => ApiUserModel.fromJson(i))
          .toList(),
      links: PaginationLinks.fromJson(json['links']),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}

class PaginationLinks {
  final String first;
  final String last;
  final String? next;
  final String? prev;

  PaginationLinks({
    required this.first,
    required this.last,
    this.next,
    this.prev,
  });

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      first: json['first'],
      last: json['last'],
      next: json['next'],
      prev: json['prev'],
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int from;
  final int lastPage;

  PaginationMeta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
    );
  }
}