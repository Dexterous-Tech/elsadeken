class PackagesModel {
  List<Data>? data;
  String? message;
  String? type;
  int? status;
  bool? showToast;

  PackagesModel(
      {this.data, this.message, this.type, this.status, this.showToast});

  PackagesModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  int? countMonths;
  int? price;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.countMonths,
      this.price,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countMonths = json['count_months'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['count_months'] = countMonths;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
