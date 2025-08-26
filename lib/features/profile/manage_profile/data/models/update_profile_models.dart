class UpdateProfileLoginDataRequestModel {
  UpdateProfileLoginDataRequestModel({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.passwordConfirmation,
  });

  UpdateProfileLoginDataRequestModel.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }
  String? name;
  String? email;
  String? phone;
  String? password;
  String? passwordConfirmation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null && name!.isNotEmpty) map['name'] = name;
    if (email != null && email!.isNotEmpty) map['email'] = email;
    if (phone != null && phone!.isNotEmpty) map['phone'] = phone;
    if (password != null && password!.isNotEmpty) map['password'] = password;
    if (passwordConfirmation != null && passwordConfirmation!.isNotEmpty) {
      map['password_confirmation'] = passwordConfirmation;
    }
    return map;
  }
}

class UpdateProfileLocationDataModel {
  UpdateProfileLocationDataModel({
    this.nationalityId,
    this.countryId,
    this.cityId,
  });

  UpdateProfileLocationDataModel.fromJson(dynamic json) {
    nationalityId = json['nationality_id'];
    countryId = json['country_id'];
    cityId = json['city_id'];
  }
  int? nationalityId;
  int? countryId;
  int? cityId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (nationalityId != null) map['nationality_id'] = nationalityId;
    if (countryId != null) map['country_id'] = countryId;
    if (cityId != null) map['city_id'] = cityId;
    return map;
  }
}

class UpdateProfileMarriageDataModel {
  UpdateProfileMarriageDataModel({
    this.maritalStatus,
    this.typeOfMarriage,
    this.childrenNumber,
    this.age,
  });

  UpdateProfileMarriageDataModel.fromJson(dynamic json) {
    maritalStatus = json['marital_status'];
    typeOfMarriage = json['type_of_marriage'];
    childrenNumber = json['children_number'];
    age = json['age'];
  }
  String? maritalStatus;
  String? typeOfMarriage;
  int? childrenNumber;
  int? age;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (maritalStatus != null && maritalStatus!.isNotEmpty)
      map['marital_status'] = maritalStatus;
    if (typeOfMarriage != null && typeOfMarriage!.isNotEmpty)
      map['type_of_marriage'] = typeOfMarriage;
    if (childrenNumber != null) map['children_number'] = childrenNumber;
    if (age != null) map['age'] = age;
    return map;
  }
}

class UpdateProfilePhysicalDataModel {
  UpdateProfilePhysicalDataModel({
    this.weight,
    this.height,
    this.skinColorId,
    this.physiqueId,
  });

  UpdateProfilePhysicalDataModel.fromJson(dynamic json) {
    weight = json['weight'];
    height = json['height'];
    skinColorId = json['skin_color_id'];
    physiqueId = json['physique_id'];
  }
  int? weight;
  int? height;
  int? skinColorId;
  int? physiqueId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (weight != null) map['weight'] = weight;
    if (height != null) map['height'] = height;
    if (skinColorId != null) map['skin_color_id'] = skinColorId;
    if (physiqueId != null) map['physique_id'] = physiqueId;
    return map;
  }
}

class UpdateProfileReligiousDataModel {
  UpdateProfileReligiousDataModel({
    this.religiousCommitment,
    this.prayer,
    this.smoking,
    this.hijab,
  });

  UpdateProfileReligiousDataModel.fromJson(dynamic json) {
    religiousCommitment = json['religious_commitment'];
    prayer = json['prayer'];
    smoking = json['smoking'];
    hijab = json['hijab'];
  }
  String? religiousCommitment;
  String? prayer;
  int? smoking;
  String? hijab;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (religiousCommitment != null && religiousCommitment!.isNotEmpty) {
      map['religious_commitment'] = religiousCommitment;
    }
    if (prayer != null && prayer!.isNotEmpty) map['prayer'] = prayer;
    if (smoking != null) map['smoking'] = smoking;
    if (hijab != null && hijab!.isNotEmpty) map['hijab'] = hijab;
    return map;
  }
}

class UpdateProfileWorkDataModel {
  UpdateProfileWorkDataModel({
    this.qualificationId,
    this.income,
    this.job,
    this.healthConditionId,
    this.financialSituationId,
  });

  UpdateProfileWorkDataModel.fromJson(dynamic json) {
    qualificationId = json['qualification_id'];
    income = json['income'];
    job = json['job'];
    healthConditionId = json['health_condition_id'];
    financialSituationId = json['financial_situation_id'];
  }
  String? qualificationId;
  int? income;
  String? job;
  String? healthConditionId;
  String? financialSituationId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (qualificationId != null && qualificationId!.isNotEmpty) {
      map['qualification_id'] = qualificationId;
    }
    if (income != null) map['income'] = income;
    if (job != null && job!.isNotEmpty) map['job'] = job;
    if (healthConditionId != null && healthConditionId!.isNotEmpty) {
      map['health_condition_id'] = healthConditionId;
    }
    if (financialSituationId != null && financialSituationId!.isNotEmpty) {
      map['financial_situation_id'] = financialSituationId;
    }
    return map;
  }
}

class UpdateProfileAboutPartnerDataModel {
  UpdateProfileAboutPartnerDataModel({
    this.lifePartner,
  });

  UpdateProfileAboutPartnerDataModel.fromJson(dynamic json) {
    lifePartner = json['life_partner'];
  }
  String? lifePartner;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (lifePartner != null && lifePartner!.isNotEmpty) {
      map['life_partner'] = lifePartner;
    }
    return map;
  }
}

class UpdateProfileAboutMeDataModel {
  UpdateProfileAboutMeDataModel({
    this.aboutMe,
  });

  UpdateProfileAboutMeDataModel.fromJson(dynamic json) {
    aboutMe = json['about_me'];
  }
  String? aboutMe;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (aboutMe != null && aboutMe!.isNotEmpty) {
      map['about_me'] = aboutMe;
    }
    return map;
  }
}
