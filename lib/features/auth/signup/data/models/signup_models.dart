import 'package:dio/dio.dart';

class SignupRequestBodyModel {
  final String name;
  final String email;
  final String gender;
  final String countryCode;
  final String phone;
  final String password;
  final String passwordConfirmation;

  SignupRequestBodyModel(
      {required this.name,
      required this.email,
      required this.gender,
      required this.countryCode,
      required this.phone,
      required this.password,
      required this.passwordConfirmation});

  FormData toFormData() {
    return FormData.fromMap({
      'email': email,
      'name': name,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
      'country_code': countryCode,
      'gender': gender,
    });
  }
}

class RegisterInformationRequestModel {
  final int nationalId;
  final int countryId;
  final int cityId;
  final String maritalStatus; //single,married,divorced,widwed
  final String typeOfMarriage; //only_one  ,
  final int age;
  final int childrenNumber;
  final int weight;
  final int height;
  final int skinColor; // white  ,
  final int physique; //
  final String religiousCommitment;
  final String prayer; //always , interittent ,no_pray
  final int smoking; //0=> no , 1 =>yes
  final String hijab;
  final String beard; //beard for males
  final int educationalQualification; //
  final int financialSituation; //bad , good, very_good
  final String job;
  final int income;
  final int healthCondition; //bad , good, very_good
  final String aboutMe;
  final String lifePartner;

  RegisterInformationRequestModel({
    required this.nationalId,
    required this.countryId,
    required this.cityId,
    required this.maritalStatus,
    required this.typeOfMarriage,
    required this.age,
    required this.childrenNumber,
    required this.weight,
    required this.height,
    required this.skinColor,
    required this.physique,
    required this.religiousCommitment,
    required this.prayer,
    required this.smoking,
    required this.hijab,
    required this.beard,
    required this.educationalQualification,
    required this.financialSituation,
    required this.job,
    required this.income,
    required this.healthCondition,
    required this.aboutMe,
    required this.lifePartner,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'nationality_id': nationalId,
      'country_id': countryId,
      'city_id': cityId,
      'marital_status': maritalStatus,
      'type_of_marriage': typeOfMarriage,
      'age': age,
      'children_number': childrenNumber,
      'weight': weight,
      'height': height,
      'skin_color_id': skinColor,
      'physique_id': physique,
      'religious_commitment': religiousCommitment,
      'prayer': prayer,
      'smoking': smoking,
      'hijab': hijab,
      'beard': beard,
      'qualification_id': educationalQualification,
      'financial_situation_id': financialSituation,
      'job': job,
      'income': income,
      'health_condition_id': healthCondition,
      'about_me': aboutMe,
      'life_partner': lifePartner,
    });
  }
}

class RegisterInformationResponseModel {
  final String message;
  final String type;
  final int status;
  final bool showToast;
  RegisterInformationResponseModel({
    required this.message,
    required this.type,
    required this.status,
    required this.showToast,
  });

  factory RegisterInformationResponseModel.fromJson(dynamic json) {
    return RegisterInformationResponseModel(
      message: json['message'],
      type: json['type'],
      status: json['status'],
      showToast: json['showToast'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['type'] = type;
    map['status'] = status;
    map['showToast'] = showToast;
    return map;
  }
}

class SignupResponseModel {
  final String message;
  final String type;
  final int status;
  final bool showToast;
  final SignupDataModel? data;

  SignupResponseModel({
    required this.message,
    required this.type,
    required this.status,
    required this.showToast,
    this.data,
  });

  factory SignupResponseModel.fromJson(dynamic json) {
    return SignupResponseModel(
      data:
          json['data'] != null ? SignupDataModel.fromJson(json['data']) : null,
      message: json['message'],
      type: json['type'],
      status: json['status'],
      showToast: json['showToast'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['type'] = type;
    map['status'] = status;
    map['showToast'] = showToast;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class SignupDataModel {
  final String phone;
  final String email;
  final String token;

  SignupDataModel(
      {required this.phone, required this.email, required this.token});

  factory SignupDataModel.fromJson(dynamic json) {
    return SignupDataModel(
      phone: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = phone;
    map['email'] = email;
    map['token'] = token;
    return map;
  }
}
