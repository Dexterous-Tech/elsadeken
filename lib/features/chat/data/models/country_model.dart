class CountryModel {
  final int id;
  final String name;

  CountryModel({
    required this.id,
    required this.name,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  CountryModel copyWith({
    int? id,
    String? name,
  }) {
    return CountryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'CountryModel(id: $id, name: $name)';
  }
}
