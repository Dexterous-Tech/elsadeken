class ChatSettingsModel {
  final int id; // Every user always has their own chat settings ID
  final int userId;
  final int fromAge;
  final int toAge;
  final int nationalityId;
  final int countryId;
  final String createdAt;
  final String updatedAt;

  ChatSettingsModel({
    required this.id, // Required ID - every user has one
    required this.userId,
    required this.fromAge,
    required this.toAge,
    required this.nationalityId,
    required this.countryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSettingsModel.fromJson(Map<String, dynamic> json) {
    return ChatSettingsModel(
      id: json['id'] ?? 0, // Every user has an ID
      userId: json['user_id'] ?? 0,
      fromAge: json['from_age'] ?? 0,
      toAge: json['to_age'] ?? 0,
      nationalityId: json['nationality_id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Always include ID
      'user_id': userId,
      'from_age': fromAge,
      'to_age': toAge,
      'nationality_id': nationalityId,
      'country_id': countryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  ChatSettingsModel copyWith({
    int? id,
    int? userId,
    int? fromAge,
    int? toAge,
    int? nationalityId,
    int? countryId,
    String? createdAt,
    String? updatedAt,
  }) {
    return ChatSettingsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fromAge: fromAge ?? this.fromAge,
      toAge: toAge ?? this.toAge,
      nationalityId: nationalityId ?? this.nationalityId,
      countryId: countryId ?? this.countryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
