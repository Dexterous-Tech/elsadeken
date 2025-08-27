class AssignPackageToUserModel {
  Null data;
  String? message;
  String? type;
  int? status;
  bool? showToast;

  AssignPackageToUserModel(
      {this.data, this.message, this.type, this.status, this.showToast});

  AssignPackageToUserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['message'] = message;
    data['type'] = type;
    data['status'] = status;
    data['showToast'] = showToast;
    return data;
  }
}
