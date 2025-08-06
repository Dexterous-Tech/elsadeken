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
  final String? educationLevel;
  final String? sortBy;

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
    this.educationLevel,
    this.sortBy,
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
    String? educationLevel,
    String? sortBy,
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
      educationLevel: educationLevel ?? this.educationLevel,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}