class ProfileActionResponseModel {
  ProfileActionResponseModel({
    this.data,
    this.message,
    this.type,
    this.status,
    this.showToast,
  });

  ProfileActionResponseModel.fromJson(dynamic json) {
    data =
        json['data'] != null ? ProfileActionData.fromJson(json['data']) : null;
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }
  ProfileActionData? data;
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

class ProfileActionData {
  ProfileActionData({
    this.image,
  });

  ProfileActionData.fromJson(dynamic json) {
    image = json['image'];
  }
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = image;
    return map;
  }
}
