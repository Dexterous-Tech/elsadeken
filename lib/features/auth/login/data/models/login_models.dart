class LoginResponseModel {
  final LoginDataModel? data;
  final String message;
  final String type;
  final int status;
  final bool showToast;
  LoginResponseModel({
    this.data,
    required this.message,
    required this.type,
    required this.status,
    required this.showToast,
  });

  factory LoginResponseModel.fromJson(dynamic json) {
    return LoginResponseModel(
      data: json['data'] != null ? LoginDataModel.fromJson(json['data']) : null,
      message: json['message'],
      type: json['type'],
      status: json['status'],
      showToast: json['showToast'],
    );
  }

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

class LoginDataModel {
  final int id;
  final String name;
  final String email;
  final String countryCode;
  final String phone;
  final String gender;
  final String? image;
  String? fcmToken;
  final String token;
  final String createdAt;
  final int? isBlocked;

  LoginDataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.phone,
    required this.gender,
    this.image,
    this.fcmToken,
    required this.token,
    required this.createdAt,
    this.isBlocked,
  });

  factory LoginDataModel.fromJson(dynamic json) {
    return LoginDataModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      countryCode: json['country_code'],
      phone: json['phone'],
      gender: json['gender'],
      image: json['image'],
      fcmToken: json['fcm_token'],
      token: json['token'],
      createdAt: json['created_at'],
      isBlocked: json['is_blocked'],
    );
  }

  // String get country => null;

  // String get city => null;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['phone'] = phone;
    map['gender'] = gender;
    map['image'] = image;
    map['fcm_token'] = fcmToken;
    map['token'] = token;
    map['created_at'] = createdAt;
    map['is_blocked'] = isBlocked;
    return map;
  }
}

class LoginRequestBodyModel {
  final String email;
  final String password;

  LoginRequestBodyModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['password'] = password;
    return map;
  }

  factory LoginRequestBodyModel.fromJson(dynamic json) {
    return LoginRequestBodyModel(
        email: json['email'], password: json['password']);
  }
}
