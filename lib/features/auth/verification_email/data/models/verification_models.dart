class VerificationResponseModel {
  final VerificationDataModel? data;
  final String message;
  final String type;
  final int status;
  final bool showToast;
  VerificationResponseModel({
    this.data,
    required this.message,
    required this.type,
    required this.status,
    required this.showToast,
  });

  factory VerificationResponseModel.fromJson(dynamic json) {
    return VerificationResponseModel(
      data: json['data'] != null
          ? VerificationDataModel.fromJson(json['data'])
          : null,
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

class VerificationDataModel {
  final String token;
  final String email;
  final String createdAt;

  VerificationDataModel({
    required this.token,
    required this.email,
    required this.createdAt,
  });

  factory VerificationDataModel.fromJson(dynamic json) {
    return VerificationDataModel(
      token: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = token;
    map['email'] = email;
    map['created_at'] = createdAt;
    return map;
  }
}

class VerificationRequestBodyModel {
  final String email;
  final String otp;

  VerificationRequestBodyModel({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['otp'] = otp;
    return map;
  }

  factory VerificationRequestBodyModel.fromJson(dynamic json) {
    return VerificationRequestBodyModel(email: json['email'], otp: json['otp']);
  }
}
