class NationalityModel {
  final int id;
  final Map<String, String> name;

  NationalityModel({
    required this.id,
    required this.name,
  });

  factory NationalityModel.fromJson(Map<String, dynamic> json) {
    return NationalityModel(
      id: json['id'] ?? 0,
      name: _parseName(json['name']),
    );
  }

  static Map<String, String> _parseName(dynamic nameData) {
    if (nameData is Map<String, dynamic>) {
      return {
        'male': nameData['male']?.toString() ?? '',
        'female': nameData['female']?.toString() ?? '',
      };
    } else if (nameData is String) {
      // Fallback for old format
      return {
        'male': nameData,
        'female': nameData,
      };
    }
    return {
      'male': '',
      'female': '',
    };
  }

  /// Get the appropriate name based on gender
  String getNameForGender(String gender) {
    // Handle male variations
    if (gender.toLowerCase() == 'male' || gender == 'ذكر') {
      return name['male'] ?? '';
    }
    // Handle female variations (including different Arabic spellings)
    else if (gender.toLowerCase() == 'female' ||
        gender == 'أنثى' ||
        gender == 'انثى' ||
        gender == 'انثي') {
      return name['female'] ?? '';
    }
    // Default to male name if gender is not recognized
    return name['male'] ?? '';
  }

  /// Get display name (for backward compatibility)
  String get displayName => name['male'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  NationalityModel copyWith({
    int? id,
    Map<String, String>? name,
  }) {
    return NationalityModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'NationalityModel(id: $id, name: $name)';
  }
}
