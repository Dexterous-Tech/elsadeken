class ProfileDetailsActionResponseModel {
  ProfileDetailsActionResponseModel({
    this.message,
    this.type,
    this.status,
    this.showToast,
  });

  ProfileDetailsActionResponseModel.fromJson(dynamic json) {
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }

  String? message;
  String? type;
  int? status;
  bool? showToast;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['type'] = type;
    map['status'] = status;
    map['showToast'] = showToast;
    return map;
  }
}
