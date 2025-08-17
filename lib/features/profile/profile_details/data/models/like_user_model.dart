class LikeUserResponseModel {
  LikeUserResponseModel({
    this.data,
    this.message,
    this.type,
    this.status,
    this.showToast,
  });

  LikeUserResponseModel.fromJson(dynamic json) {
    data = json['data'];
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }

  dynamic data;
  String? message;
  String? type;
  int? status;
  bool? showToast;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data;
    map['message'] = message;
    map['type'] = type;
    map['status'] = status;
    map['showToast'] = showToast;
    return map;
  }
}
