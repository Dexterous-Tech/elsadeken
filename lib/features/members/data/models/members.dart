import 'package:elsadeken/features/members/data/models/members_attribute.dart';

class Member {
  final int id;
  final String name;
  final String email;
  final String countryCode;
  final String phone;
  final String gender;
  final String image;
  final String createdAt;
  final MemberAttribute? attribute;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.phone,
    required this.gender,
    required this.image,
    required this.createdAt,
    required this.attribute,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    // Debug: Print the JSON being parsed
    print('Parsing Member from JSON: $json');
    print('Attribute JSON: ${json['attribute']}');

    return Member(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['country_code'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      attribute: json['attribute'] == null
          ? null
          : MemberAttribute.fromJson(json['attribute']),
    );
  }
}
