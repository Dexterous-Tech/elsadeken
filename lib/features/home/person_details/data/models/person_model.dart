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
    try {
      print("Parsing PersonModel from JSON: $json");

      // Check if required fields exist
      if (json['id'] == null) {
        throw Exception("Person ID is required but not found in JSON");
      }

      if (json['attribute'] == null) {
        throw Exception("Person attribute is required but not found in JSON");
      }

      return PersonModel(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString()) ?? 0,
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        gender: json['gender']?.toString() ?? '',
        image: json['image']?.toString() ?? '',
        createdAt: json['created_at']?.toString() ?? '',
        attribute: Attribute.fromJson(json['attribute']),
      );
    } catch (e) {
      print("Error parsing PersonModel: $e");
      print("JSON that caused error: $json");
      rethrow;
    }
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
    try {
      print("Parsing Attribute from JSON: $json");

      return Attribute(
        nationality: json['nationality']?.toString() ?? '',
        city: json['city']?.toString() ?? '',
        country: json['country']?.toString() ?? '',
        skinColor: json['skin_color']?.toString() ?? '',
        healthCondition: json['health_condition']?.toString() ?? '',
        physique: json['physique']?.toString() ?? '',
        qualification: json['qualification']?.toString() ?? '',
        financialSituation: json['financial_situation']?.toString() ?? '',
        maritalStatus: json['marital_status']?.toString() ?? '',
        typeOfMarriage: json['type_of_marriage']?.toString() ?? '',
        age: json['age'] is int
            ? json['age']
            : int.tryParse(json['age']?.toString() ?? '0') ?? 0,
        children: json['children'] is int
            ? json['children']
            : int.tryParse(json['children']?.toString() ?? '0') ?? 0,
        weight: json['weight'] is int
            ? json['weight']
            : int.tryParse(json['weight']?.toString() ?? '0') ?? 0,
        height: json['height'] is int
            ? json['height']
            : int.tryParse(json['height']?.toString() ?? '0') ?? 0,
        religiousCommitment: json['religious_commitment']?.toString() ?? '',
        prayer: json['prayer']?.toString() ?? '',
        smoking: json['smoking']?.toString() ?? '',
        hijab: json['hijab']?.toString() ?? '',
        job: json['job']?.toString() ?? '',
        income: json['income'] is int
            ? json['income']
            : int.tryParse(json['income']?.toString() ?? '0') ?? 0,
        lifePartner: json['life_partner']?.toString() ?? '',
        aboutMe: json['about_me']?.toString() ?? '',
      );
    } catch (e) {
      print("Error parsing Attribute: $e");
      print("JSON that caused error: $json");
      rethrow;
    }
  }
}
