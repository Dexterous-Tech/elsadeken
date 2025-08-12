class ForgetResponseModel {
  final ForgetDataModel? data;
  final String message;
  final String type;
  final int status;
  final bool showToast;
  ForgetResponseModel({
    this.data,
    required this.message,
    required this.type,
    required this.status,
    required this.showToast,
  });

  factory ForgetResponseModel.fromJson(dynamic json) {
    return ForgetResponseModel(
      data:
          json['data'] != null ? ForgetDataModel.fromJson(json['data']) : null,
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

class ForgetDataModel {
  final int id;
  final String name;
  final String email;
  final String otpExpiresAt;

  ForgetDataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.otpExpiresAt,
  });

  factory ForgetDataModel.fromJson(dynamic json) {
    return ForgetDataModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      otpExpiresAt: json['otp_expires_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['otp_expires_at'] = otpExpiresAt;
    return map;
  }
}

class ForgetRequestBodyModel {
  final String email;

  ForgetRequestBodyModel({required this.email});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    return map;
  }

  factory ForgetRequestBodyModel.fromJson(dynamic json) {
    return ForgetRequestBodyModel(email: json['email']);
  }
}
