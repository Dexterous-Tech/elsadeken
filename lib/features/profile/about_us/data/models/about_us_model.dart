class AboutUsResponseModel {
  AboutUsResponseModel({
    this.data,
    this.message,
    this.type,
    this.status,
    this.showToast,
  });

  AboutUsResponseModel.fromJson(dynamic json) {
    data =
        json['data'] != null ? AboutUsDataModel.fromJson(json['data']) : null;
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }
  AboutUsDataModel? data;
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

class AboutUsDataModel {
  AboutUsDataModel({
    this.id,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  AboutUsDataModel.fromJson(dynamic json) {
    id = json['id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? description;
  dynamic createdAt;
  dynamic updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['description'] = description;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
