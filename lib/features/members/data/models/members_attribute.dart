class MemberAttribute {
  final int id;
  final String city;
  final String country;
  final String maritalStatus;
  final String typeOfMarriage;
  final int age;
  final int children;
  final int weight;
  final int height;
  final String religiousCommitment;
  final String prayer;
  final String smoking;
  final String hijab;
  final String job;
  final int income;
  final String lifePartner;
  final String aboutMe;

  MemberAttribute({
    required this.id,
    required this.city,
    required this.country,
    required this.maritalStatus,
    required this.typeOfMarriage,
    required this.age,
    required this.children,
    required this.weight,
    required this.height,
    required this.religiousCommitment,
    required this.prayer,
    required this.smoking,
    required this.hijab,
    required this.job,
    required this.income,
    required this.lifePartner,
    required this.aboutMe,
  });

  factory MemberAttribute.fromJson(Map<String, dynamic> json) {
    // Debug: Print the attribute JSON being parsed
    print('Parsing MemberAttribute from JSON: $json');
    print('City from JSON: ${json['city']}');
    print('Country from JSON: ${json['country']}');
    
    return MemberAttribute(
      id: json['id'] ?? 0,
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      maritalStatus: json['marital_status'] ?? '',
      typeOfMarriage: json['type_of_marriage'] ?? '',
      age: json['age'] ?? 0,
      children: json['children'] ?? 0,
      weight: json['weight'] ?? 0,
      height: json['height'] ?? 0,
      religiousCommitment: json['religious_commitment'] ?? '',
      prayer: json['prayer'] ?? '',
      smoking: json['smoking'] ?? '',
      hijab: json['hijab'] ?? '',
      job: json['job'] ?? '',
      income: json['income'] ?? 0,
      lifePartner: json['life_partner'] ?? '',
      aboutMe: json['about_me'] ?? '',
    );
  }
}
