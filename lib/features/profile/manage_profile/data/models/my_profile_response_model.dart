class MyProfileResponseModel {
  MyProfileResponseModel({
    this.data,
    this.message,
    this.type,
    this.status,
    this.showToast,
  });

  MyProfileResponseModel.fromJson(dynamic json) {
    data =
        json['data'] != null ? MyProfileDataModel.fromJson(json['data']) : null;
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }
  MyProfileDataModel? data;
  String? message;
  String? type;
  int? status;
  bool? showToast;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    map['type'] = type;
    map['status'] = status;
    map['showToast'] = showToast;
    return map;
  }
}

class MyProfileAttributeModel {
  MyProfileAttributeModel({
    this.id,
    this.nationality,
    this.city,
    this.country,
    this.skinColor,
    this.healthCondition,
    this.physique,
    this.qualification,
    this.financialSituation,
    this.maritalStatus,
    this.typeOfMarriage,
    this.age,
    this.children,
    this.weight,
    this.height,
    this.religiousCommitment,
    this.prayer,
    this.smoking,
    this.hijab,
    this.job,
    this.income,
    this.lifePartner,
    this.aboutMe,
  });

  MyProfileAttributeModel.fromJson(dynamic json) {
    id = json['id'];
    nationality = json['nationality'];
    city = json['city'];
    country = json['country'];
    skinColor = json['skin_color'];
    healthCondition = json['health_condition'];
    physique = json['physique'];
    qualification = json['qualification'];
    financialSituation = json['financial_situation'];
    maritalStatus = json['marital_status'];
    typeOfMarriage = json['type_of_marriage'];
    age = json['age'];
    children = json['children'];
    weight = json['weight'];
    height = json['height'];
    religiousCommitment = json['religious_commitment'];
    prayer = json['prayer'];
    smoking = json['smoking'];
    hijab = json['hijab'];
    job = json['job'];
    income = json['income'];
    lifePartner = json['life_partner'];
    aboutMe = json['about_me'];
  }
  int? id;
  String? nationality;
  String? city;
  String? country;
  String? skinColor;
  String? healthCondition;
  String? physique;
  String? qualification;
  String? financialSituation;
  String? maritalStatus;
  String? typeOfMarriage;
  int? age;
  int? children;
  int? weight;
  int? height;
  String? religiousCommitment;
  String? prayer;
  String? smoking;
  String? hijab;
  String? job;
  int? income;
  String? lifePartner;
  String? aboutMe;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nationality'] = nationality;
    map['city'] = city;
    map['country'] = country;
    map['skin_color'] = skinColor;
    map['health_condition'] = healthCondition;
    map['physique'] = physique;
    map['qualification'] = qualification;
    map['financial_situation'] = financialSituation;
    map['marital_status'] = maritalStatus;
    map['type_of_marriage'] = typeOfMarriage;
    map['age'] = age;
    map['children'] = children;
    map['weight'] = weight;
    map['height'] = height;
    map['religious_commitment'] = religiousCommitment;
    map['prayer'] = prayer;
    map['smoking'] = smoking;
    map['hijab'] = hijab;
    map['job'] = job;
    map['income'] = income;
    map['life_partner'] = lifePartner;
    map['about_me'] = aboutMe;
    return map;
  }
}

class MyProfileDataModel {
  MyProfileDataModel({
    this.id,
    this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.gender,
    this.image,
    this.isFeatured,
    this.createdAt,
    this.attribute,
  });

  MyProfileDataModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    gender = json['gender'];
    image = json['image'];
    isFeatured = json['is_featured'];
    createdAt = json['created_at'];
    attribute = json['attribute'] != null
        ? MyProfileAttributeModel.fromJson(json['attribute'])
        : null;
  }
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? phone;
  String? gender;
  String? image;
  int? isFeatured;
  String? createdAt;
  MyProfileAttributeModel? attribute;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['phone'] = phone;
    map['gender'] = gender;
    map['image'] = image;
    map['is_featured'] = isFeatured;
    map['created_at'] = createdAt;
    if (attribute != null) {
      map['attribute'] = attribute?.toJson();
    }
    return map;
  }
}
