class ChatOnlineSettingModel {
  ChatOnlineSettingModel({
    this.data,
    this.message,
    this.type,
    this.status,
    this.showToast,
  });

  ChatOnlineSettingModel.fromJson(dynamic json) {
    data = json['data'] != null
        ? ChatOnlineDataModel.fromJson(json['data'])
        : null;
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }
  ChatOnlineDataModel? data;
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

class ChatOnlineDataModel {
  ChatOnlineDataModel({
    this.enableOnline,
  });

  ChatOnlineDataModel.fromJson(dynamic json) {
    enableOnline = json['enable_online'];
  }
  int? enableOnline;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enable_online'] = enableOnline;
    return map;
  }
}
