class ChatSettingsRequestModel {
  final int? fromAge;
  final int? toAge;
  final int? nationalityId;
  final int? countryId;

  ChatSettingsRequestModel({
    this.fromAge,
    this.toAge,
    this.nationalityId,
    this.countryId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (fromAge != null) data['from_age'] = fromAge;
    if (toAge != null) data['to_age'] = toAge;
    if (nationalityId != null) data['nationality_id'] = nationalityId;
    if (countryId != null) data['country_id'] = countryId;
    
    return data;
  }

  ChatSettingsRequestModel copyWith({
    int? fromAge,
    int? toAge,
    int? nationalityId,
    int? countryId,
  }) {
    return ChatSettingsRequestModel(
      fromAge: fromAge ?? this.fromAge,
      toAge: toAge ?? this.toAge,
      nationalityId: nationalityId ?? this.nationalityId,
      countryId: countryId ?? this.countryId,
    );
  }
}

