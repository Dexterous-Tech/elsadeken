class FeaturesModel {
  List<Data>? data;
  String? message;
  String? type;
  int? status;
  bool? showToast;

  FeaturesModel(
      {this.data, this.message, this.type, this.status, this.showToast});

  FeaturesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['type'] = type;
    data['status'] = status;
    data['showToast'] = showToast;
    return data;
  }
}

class Data {
  String? feature;
  int? active;

  Data({this.feature, this.active});

  Data.fromJson(Map<String, dynamic> json) {
    feature = json['feature'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feature'] = feature;
    data['active'] = active;
    return data;
  }
}
