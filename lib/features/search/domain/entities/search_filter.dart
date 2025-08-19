// File: lib/domain/entities/search_filter.dart
class SearchFilter {
  final String? username;
  final String? quickSearch;
  final String? advancedSearch;
  final String? nationality;
  final String? country;
  final String? city;
  final String? maritalStatus;
  final String? socialStatus;
  final int? ageFrom;
  final int? ageTo;
  final int? heightFrom;
  final int? heightTo;
  final int? weightFrom;
  final int? weightTo;
  final String? skinColor;
  final String? qualificationId; 
  final int? latest; 
  final String? typeOfMarriage;

  SearchFilter({
    this.username,
    this.quickSearch,
    this.advancedSearch,
    this.nationality,
    this.country,
    this.city,
    this.maritalStatus,
    this.socialStatus,
    this.ageFrom,
    this.ageTo,
    this.heightFrom,
    this.heightTo,
    this.weightFrom,
    this.weightTo,
    this.skinColor,
    this.qualificationId,
    this.latest,
    this.typeOfMarriage,
  });

  SearchFilter copyWith({
    String? username,
    String? quickSearch,
    String? advancedSearch,
    String? nationality,
    String? country,
    String? city,
    String? maritalStatus,
    String? socialStatus,
    int? ageFrom,
    int? ageTo,
    int? heightFrom,
    int? heightTo,
    int? weightFrom,
    int? weightTo,
    String? skinColor,
    String? qualificationId,
    int? latest,
    String? typeOfMarriage,
  }) {
    return SearchFilter(
      username: username ?? this.username,
      quickSearch: quickSearch ?? this.quickSearch,
      advancedSearch: advancedSearch ?? this.advancedSearch,
      nationality: nationality ?? this.nationality,
      country: country ?? this.country,
      city: city ?? this.city,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      socialStatus: socialStatus ?? this.socialStatus,
      ageFrom: ageFrom ?? this.ageFrom,
      ageTo: ageTo ?? this.ageTo,
      heightFrom: heightFrom ?? this.heightFrom,
      heightTo: heightTo ?? this.heightTo,
      weightFrom: weightFrom ?? this.weightFrom,
      weightTo: weightTo ?? this.weightTo,
      skinColor: skinColor ?? this.skinColor,
      qualificationId: qualificationId ?? this.qualificationId,
      latest: latest ?? this.latest,
      typeOfMarriage: typeOfMarriage ?? this.typeOfMarriage,
    );
  }

  Map<String, dynamic> toJson({int page = 1}) {
    final Map<String, dynamic> data = {
      "page": page,
    };
    if (username?.isNotEmpty ?? false) data["user_name"] = username;
    if (nationality != null) data["nationality_id"] = nationality.toString();
    if (city != null) data["city_id"] = city.toString();
    if (country != null) data["country_id"] = country.toString();
    if (maritalStatus?.isNotEmpty ?? false) data["type_of_marrige"] = maritalStatus;
    if (socialStatus?.isNotEmpty ?? false) data["martital_status"] = socialStatus;
    if (ageFrom != null) data["from_age"] = ageFrom.toString();
    if (ageTo != null) data["to_age"] = ageTo.toString();
    if (weightFrom != null) data["from_weight"] = weightFrom.toString();
    if (weightTo != null) data["to_weight"] = weightTo.toString();
    if (heightFrom != null) data["from_height"] = heightFrom.toString();
    if (heightTo != null) data["to_height"] = heightTo.toString();
    if (skinColor?.isNotEmpty ?? false) data["skin_color_id"] = skinColor;
    if (qualificationId?.isNotEmpty ?? false) data["qualification_id"] = qualificationId;
    if (latest != null) data["latest"] = latest;
    if (typeOfMarriage?.isNotEmpty ?? false) data["type_of_marriage"] = typeOfMarriage;
    return data;
  }

}
