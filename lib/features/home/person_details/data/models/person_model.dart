class PersonModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String image;
  final String createdAt;
  final Attribute attribute;

  PersonModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.image,
    required this.createdAt,
    required this.attribute,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      attribute: Attribute.fromJson(json['attribute']),
    );
  }
}

class Attribute {
  final String nationality;
  final String city;
  final String country;
  final String skinColor;
  final String healthCondition;
  final String physique;
  final String qualification;
  final String financialSituation;
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

  Attribute({
    required this.nationality,
    required this.city,
    required this.country,
    required this.skinColor,
    required this.healthCondition,
    required this.physique,
    required this.qualification,
    required this.financialSituation,
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

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      nationality: json['nationality'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      skinColor: json['skin_color'] ?? '',
      healthCondition: json['health_condition'] ?? '',
      physique: json['physique'] ?? '',
      qualification: json['qualification'] ?? '',
      financialSituation: json['financial_situation'] ?? '',
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
