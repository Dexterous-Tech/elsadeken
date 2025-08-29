class NationalityModel {
  final int id;
  final String name;

  NationalityModel({
    required this.id,
    required this.name,
  });

  factory NationalityModel.fromJson(Map<String, dynamic> json) {
    return NationalityModel(
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

  NationalityModel copyWith({
    int? id,
    String? name,
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
