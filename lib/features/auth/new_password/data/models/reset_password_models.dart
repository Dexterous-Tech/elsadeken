class ResetPasswordResponseModel {
  // final VerificationDataModel? data;
  final String message;
  final String type;
  final int status;
  final bool showToast;
  ResetPasswordResponseModel({
    // this.data,
    required this.message,
    required this.type,
    required this.status,
    required this.showToast,
  });

  factory ResetPasswordResponseModel.fromJson(dynamic json) {
    return ResetPasswordResponseModel(
      // data: json['data'] != null
      //     ? VerificationDataModel.fromJson(json['data'])
      //     : null,
      message: json['message'],
      type: json['type'],
      status: json['status'],
      showToast: json['showToast'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // if (data != null) {
    //   map['data'] = data?.toJson();
    // }
    map['message'] = message;
    map['type'] = type;
    map['status'] = status;
    map['showToast'] = showToast;
    return map;
  }
}

// class VerificationDataModel {
//   final String token;
//   final String email;
//   final String createdAt;
//
//   VerificationDataModel({
//     required this.token,
//     required this.email,
//     required this.createdAt,
//   });
//
//   factory VerificationDataModel.fromJson(dynamic json) {
//     return VerificationDataModel(
//       token: json['name'],
//       email: json['email'],
//       createdAt: json['created_at'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['name'] = token;
//     map['email'] = email;
//     map['created_at'] = createdAt;
//     return map;
//   }
// }

class ResetPasswordRequestBodyModel {
  final String email;
  final String newPassword;
  final String newConfirmPassword;
  final String token;

  ResetPasswordRequestBodyModel(
      {required this.email,
      required this.newPassword,
      required this.newConfirmPassword,
      required this.token});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['new_password'] = newPassword;
    map['new_password_confirmation'] = newConfirmPassword;
    map['token'] = token;
    return map;
  }

  factory ResetPasswordRequestBodyModel.fromJson(dynamic json) {
    return ResetPasswordRequestBodyModel(
        email: json['email'],
        newPassword: json['otp'],
        newConfirmPassword: json['new_password_confirmation'],
        token: json['token']);
  }
}
