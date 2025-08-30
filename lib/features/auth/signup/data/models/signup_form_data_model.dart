class SignupFormDataModel {
  // Personal Info (Step 0)
  final String? name;
  final String? email;
  final String? phone;
  final String? countryCode;
  final String? gender;

  // Passwords (Step 1)
  final String? password;
  final String? passwordConfirmation;

  // National (Step 2)
  final String? nationalId;

  // Country (Step 3)
  final String? countryId;

  // City (Step 4)
  final String? cityId;

  // Social Status (Step 5)
  final String? maritalStatus;
  final String? typeOfMarriage;

  // General Info (Step 6)
  final String? age;
  final String? childrenNumber;

  // Body Shape (Step 7)
  final String? weight;
  final String? height;
  final String? skinColor;
  final String? physique;

  // Religion (Step 8)
  final String? religiousCommitment;
  final String? prayer;

  // Additions (Step 9)
  final String? smoking;
  final String? hijab;
  final String? beard;

  // Education (Step 10)
  final String? educationalQualification;

  // Job (Step 11)
  final String? financialSituation;
  final String? job;
  final String? income;
  final String? healthCondition;

  // Descriptions (Step 12)
  final String? aboutMe;
  final String? lifePartner;

  SignupFormDataModel({
    this.name,
    this.email,
    this.phone,
    this.countryCode,
    this.gender,
    this.password,
    this.passwordConfirmation,
    this.nationalId,
    this.countryId,
    this.cityId,
    this.maritalStatus,
    this.typeOfMarriage,
    this.age,
    this.childrenNumber,
    this.weight,
    this.height,
    this.skinColor,
    this.physique,
    this.religiousCommitment,
    this.prayer,
    this.smoking,
    this.hijab,
    this.beard,
    this.educationalQualification,
    this.financialSituation,
    this.job,
    this.income,
    this.healthCondition,
    this.aboutMe,
    this.lifePartner,
  });

  factory SignupFormDataModel.fromJson(Map<String, dynamic> json) {
    return SignupFormDataModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      countryCode: json['countryCode'],
      gender: json['gender'],
      password: json['password'],
      passwordConfirmation: json['passwordConfirmation'],
      nationalId: json['nationalId'],
      countryId: json['countryId'],
      cityId: json['cityId'],
      maritalStatus: json['maritalStatus'],
      typeOfMarriage: json['typeOfMarriage'],
      age: json['age'],
      childrenNumber: json['childrenNumber'],
      weight: json['weight'],
      height: json['height'],
      skinColor: json['skinColor'],
      physique: json['physique'],
      religiousCommitment: json['religiousCommitment'],
      prayer: json['prayer'],
      smoking: json['smoking'],
      hijab: json['hijab'],
      beard: json['beard'],
      educationalQualification: json['educationalQualification'],
      financialSituation: json['financialSituation'],
      job: json['job'],
      income: json['income'],
      healthCondition: json['healthCondition'],
      aboutMe: json['aboutMe'],
      lifePartner: json['lifePartner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'countryCode': countryCode,
      'gender': gender,
      'password': password,
      'passwordConfirmation': passwordConfirmation,
      'nationalId': nationalId,
      'countryId': countryId,
      'cityId': cityId,
      'maritalStatus': maritalStatus,
      'typeOfMarriage': typeOfMarriage,
      'age': age,
      'childrenNumber': childrenNumber,
      'weight': weight,
      'height': height,
      'skinColor': skinColor,
      'physique': physique,
      'religiousCommitment': religiousCommitment,
      'prayer': prayer,
      'smoking': smoking,
      'hijab': hijab,
      'beard': beard,
      'educationalQualification': educationalQualification,
      'financialSituation': financialSituation,
      'job': job,
      'income': income,
      'healthCondition': healthCondition,
      'aboutMe': aboutMe,
      'lifePartner': lifePartner,
    };
  }

  // Create a copy with updated fields
  SignupFormDataModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? countryCode,
    String? gender,
    String? password,
    String? passwordConfirmation,
    String? nationalId,
    String? countryId,
    String? cityId,
    String? maritalStatus,
    String? typeOfMarriage,
    String? age,
    String? childrenNumber,
    String? weight,
    String? height,
    String? skinColor,
    String? physique,
    String? religiousCommitment,
    String? prayer,
    String? smoking,
    String? hijab,
    String? beard,
    String? educationalQualification,
    String? financialSituation,
    String? job,
    String? income,
    String? healthCondition,
    String? aboutMe,
    String? lifePartner,
  }) {
    return SignupFormDataModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      nationalId: nationalId ?? this.nationalId,
      countryId: countryId ?? this.countryId,
      cityId: cityId ?? this.cityId,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      typeOfMarriage: typeOfMarriage ?? this.typeOfMarriage,
      age: age ?? this.age,
      childrenNumber: childrenNumber ?? this.childrenNumber,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      skinColor: skinColor ?? this.skinColor,
      physique: physique ?? this.physique,
      religiousCommitment: religiousCommitment ?? this.religiousCommitment,
      prayer: prayer ?? this.prayer,
      smoking: smoking ?? this.smoking,
      hijab: hijab ?? this.hijab,
      beard: beard ?? this.beard,
      educationalQualification:
          educationalQualification ?? this.educationalQualification,
      financialSituation: financialSituation ?? this.financialSituation,
      job: job ?? this.job,
      income: income ?? this.income,
      healthCondition: healthCondition ?? this.healthCondition,
      aboutMe: aboutMe ?? this.aboutMe,
      lifePartner: lifePartner ?? this.lifePartner,
    );
  }

  // Check if all required fields are filled
  bool get isComplete {
    return name != null &&
        name!.isNotEmpty &&
        email != null &&
        email!.isNotEmpty &&
        phone != null &&
        phone!.isNotEmpty &&
        countryCode != null &&
        countryCode!.isNotEmpty &&
        gender != null &&
        gender!.isNotEmpty &&
        password != null &&
        password!.isNotEmpty &&
        passwordConfirmation != null &&
        passwordConfirmation!.isNotEmpty &&
        nationalId != null &&
        nationalId!.isNotEmpty &&
        countryId != null &&
        countryId!.isNotEmpty &&
        cityId != null &&
        cityId!.isNotEmpty &&
        maritalStatus != null &&
        maritalStatus!.isNotEmpty &&
        typeOfMarriage != null &&
        typeOfMarriage!.isNotEmpty &&
        age != null &&
        age!.isNotEmpty &&
        childrenNumber != null &&
        childrenNumber!.isNotEmpty &&
        weight != null &&
        weight!.isNotEmpty &&
        height != null &&
        height!.isNotEmpty &&
        skinColor != null &&
        skinColor!.isNotEmpty &&
        physique != null &&
        physique!.isNotEmpty &&
        religiousCommitment != null &&
        religiousCommitment!.isNotEmpty &&
        prayer != null &&
        prayer!.isNotEmpty &&
        smoking != null &&
        smoking!.isNotEmpty &&
        educationalQualification != null &&
        educationalQualification!.isNotEmpty &&
        financialSituation != null &&
        financialSituation!.isNotEmpty &&
        job != null &&
        job!.isNotEmpty &&
        income != null &&
        income!.isNotEmpty &&
        healthCondition != null &&
        healthCondition!.isNotEmpty &&
        aboutMe != null &&
        aboutMe!.isNotEmpty &&
        lifePartner != null &&
        lifePartner!.isNotEmpty;
  }
}
