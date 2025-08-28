class NotificationResponseModel {
  NotificationResponseModel({
    this.data,
    this.links,
    this.meta,
    this.message,
    this.code,
    this.type,
  });

  NotificationResponseModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(NotificationDataModel.fromJson(v));
      });
    }
    links = json['links'] != null
        ? NotificationLinksModel.fromJson(json['links'])
        : null;
    meta = json['meta'] != null
        ? NotificationMetaModel.fromJson(json['meta'])
        : null;
    message = json['message'];
    code = json['code'];
    type = json['type'];
  }
  List<NotificationDataModel>? data;
  NotificationLinksModel? links;
  NotificationMetaModel? meta;
  String? message;
  int? code;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (links != null) {
      map['links'] = links?.toJson();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    map['message'] = message;
    map['code'] = code;
    map['type'] = type;
    return map;
  }
}

class NotificationDataModel {
  NotificationDataModel({
    this.id,
    this.userId,
    this.userName,
    this.title,
    this.body,
    this.icon,
    this.readAt,
    this.createdAt,
  });

  NotificationDataModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    title = json['title'];
    body = json['body'];
    icon = json['icon'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
  }
  String? id;
  int? userId;
  String? userName;
  String? title;
  String? body;
  String? icon;
  String? readAt;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['user_name'] = userName;
    map['title'] = title;
    map['body'] = body;
    map['icon'] = icon;
    map['read_at'] = readAt;
    map['created_at'] = createdAt;
    return map;
  }
}

class NotificationLinksModel {
  NotificationLinksModel({
    this.first,
    this.last,
    this.next,
    this.prev,
  });

  NotificationLinksModel.fromJson(dynamic json) {
    first = json['first'];
    last = json['last'];
    next = json['next'];
    prev = json['prev'];
  }
  String? first;
  String? last;
  dynamic next;
  dynamic prev;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first'] = first;
    map['last'] = last;
    map['next'] = next;
    map['prev'] = prev;
    return map;
  }
}

class NotificationMetaModel {
  NotificationMetaModel({
    this.currentPage,
    this.from,
    this.lastPage,
  });

  NotificationMetaModel.fromJson(dynamic json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
  }
  int? currentPage;
  int? from;
  int? lastPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    map['from'] = from;
    map['last_page'] = lastPage;
    return map;
  }
}
