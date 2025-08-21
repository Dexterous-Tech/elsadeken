
class NotificationCountResponseModel {
  NotificationCountResponseModel({
    this.data,
    this.message,
    this.type,
    this.status,
    this.showToast,
  });

  NotificationCountResponseModel.fromJson(dynamic json) {
    data = json['data'] != null ? NotificationCountDataModel.fromJson(json['data']) : null;
    message = json['message'];
    type = json['type'];
    status = json['status'];
    showToast = json['showToast'];
  }
  NotificationCountDataModel? data;
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

class NotificationCountDataModel {
  NotificationCountDataModel({
    this.countUnreadNotifications,
  });

  NotificationCountDataModel.fromJson(dynamic json) {
    countUnreadNotifications = json['count_unread_notifications'];
  }
  int? countUnreadNotifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count_unread_notifications'] = countUnreadNotifications;
    return map;
  }
}
