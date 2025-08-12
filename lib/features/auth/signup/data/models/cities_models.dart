class CityResponseModels {
  CityResponseModels({
    this.id,
    this.name,
    this.countryCode,
  });

  CityResponseModels.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    countryCode = json['country_code'];
  }
  int? id;
  String? name;
  dynamic countryCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['country_code'] = countryCode;
    return map;
  }
}
