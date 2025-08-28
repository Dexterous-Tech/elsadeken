import 'dart:developer';

class NotificationSettingResponseModel {
  NotificationSettingResponseModel({
    this.data,
    this.message,
    this.type,
    this.status,
    this.showToast,
  });

  NotificationSettingResponseModel.fromJson(dynamic json) {
    try {
      if (json['data'] != null && json['data'] is Map<String, dynamic>) {
        data = NotificationSettingDataModel.fromJson(json['data']);
      }
      message = json['message']?.toString();
      type = json['type']?.toString();
      status = json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '0');
      showToast = json['showToast'] ?? false;
    } catch (e) {
      log('Error parsing NotificationSettingResponseModel: $e');
      log('JSON data: $json');
      rethrow;
    }
  }
  
  NotificationSettingDataModel? data;
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
    map['status'] = status;
    map['type'] = type;
    map['showToast'] = showToast;
    return map;
  }
}

class NotificationSettingDataModel {
  NotificationSettingDataModel({
    this.id,
    this.userId,
    this.favoriteList,
    this.visitProfile,
    this.ignoreList,
    this.message,
    this.blog,
    this.ring,
    this.vibration,
    this.createdAt,
    this.updatedAt,
  });

  NotificationSettingDataModel.fromJson(dynamic json) {
    try {
      id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0');
      userId = json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '0');
      favoriteList = json['favorite_list'] == 1;
      visitProfile = json['visit_profile'] == 1;
      ignoreList = json['ignore_list'] == 1;
      message = json['message'] == 1;
      blog = json['blog'] == 1;
      ring = json['ring'] == 1;
      vibration = json['vibration'] == 1;
      createdAt = json['created_at']?.toString();
      updatedAt = json['updated_at']?.toString();
    } catch (e) {
      log('Error parsing NotificationSettingDataModel: $e');
      log('JSON data: $json');
      rethrow;
    }
  }
  
  int? id;
  int? userId;
  bool? favoriteList;
  bool? visitProfile;
  bool? ignoreList;
  bool? message;
  bool? blog;
  bool? ring;
  bool? vibration;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['favorite_list'] = favoriteList == true ? 1 : 0;
    map['visit_profile'] = visitProfile == true ? 1 : 0;
    map['ignore_list'] = ignoreList == true ? 1 : 0;
    map['message'] = message == true ? 1 : 0;
    map['blog'] = blog == true ? 1 : 0;
    map['ring'] = ring == true ? 1 : 0;
    map['vibration'] = vibration == true ? 1 : 0;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

  /// Convert settings to a list format for UI display
  List<Map<String, dynamic>> toSettingsList() {
    return [
      {
        'id': 'favorite_list',
        'title': 'من وضعني في قائمته المفضلة؟',
        'value': favoriteList ?? false,
      },
      {
        'id': 'visit_profile',
        'title': 'زيارات ملفي الشخصي',
        'value': visitProfile ?? false,
      },
      {
        'id': 'ignore_list',
        'title': 'من أضافني إلى قائمة التجاهل؟',
        'value': ignoreList ?? false,
      },
      {
        'id': 'message',
        'title': 'رسائل جديدة',
        'value': message ?? false,
      },
      {
        'id': 'blog',
        'title': 'قصص ناجحة',
        'value': blog ?? false,
      },
      {
        'id': 'ring',
        'title': 'إشعار نغمة الرنين',
        'value': ring ?? false,
      },
      {
        'id': 'vibration',
        'title': 'تنبيه بالاهتزاز',
        'value': vibration ?? false,
      },
    ];
  }
}

class UpdateNotificationSettingRequestModel {
  UpdateNotificationSettingRequestModel({
    required this.favoriteList,
    required this.visitProfile,
    required this.ignoreList,
    required this.message,
    required this.blog,
    required this.ring,
    required this.vibration,
  });

  final int favoriteList;
  final int visitProfile;
  final int ignoreList;
  final int message;
  final int blog;
  final int ring;
  final int vibration;

  Map<String, dynamic> toJson() {
    return {
      'favorite_list': favoriteList,
      'visit_profile': visitProfile,
      'ignore_list': ignoreList,
      'message': message,
      'blog': blog,
      'ring': ring,
      'vibration': vibration,
    };
  }


}

