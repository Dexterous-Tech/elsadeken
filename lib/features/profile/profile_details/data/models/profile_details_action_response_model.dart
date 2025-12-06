class ProfileDetailsActionResponseModel {
  ProfileDetailsActionResponseModel({
    this.message,
    this.type,
    this.status,
    this.showToast,
    this.data,
  });

  ProfileDetailsActionResponseModel.fromJson(dynamic json) {
    data = json['data'] != null
        ? ProfileDetailsDataActionResponseModel.fromJson(json['data'])
        : null;
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }

  ProfileDetailsDataActionResponseModel? data;
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

class ProfileDetailsDataActionResponseModel {
  ProfileDetailsDataActionResponseModel({
    this.shareUrl,
  });

  ProfileDetailsDataActionResponseModel.fromJson(dynamic json) {
    shareUrl = json['share_url'];
  }
  String? shareUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['share_url'] = shareUrl;
    return map;
  }
}
