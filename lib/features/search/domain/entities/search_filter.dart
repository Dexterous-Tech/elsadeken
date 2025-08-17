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
    );
  }

  Map<String, dynamic> toJson({int page = 1}) {
    return {
      "user_name": username,
      "nationality_id": nationality?.toString(),
      "city_id": city?.toString(),
      "country_id": country?.toString(),
      "type_of_marrige": maritalStatus,
      "martital_status": socialStatus,
      "from_age": ageFrom?.toString(),
      "to_age": ageTo?.toString(),
      "from_weight": weightFrom?.toString(),
      "to_weight": weightTo?.toString(),
      "from_height": heightFrom?.toString(),
      "to_height": heightTo?.toString(),
      "qualification_id": qualificationId,
      "latest": latest,
      "page": page,
    };
  }
}
