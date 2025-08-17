class FavUserListModel {
  List<Data>? data;
  Links? links;
  Meta? meta;
  String? message;
  int? code;
  String? type;

  FavUserListModel(
      {this.data, this.links, this.meta, this.message, this.code, this.type});

  FavUserListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    message = json['message'];
    code = json['code'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    data['type'] = this.type;
    return data;
  }
}

class Data {
  int? id;
  String name; // مش null
  String? email;
  String? countryCode;
  String? phone;
  String? gender;
  String? image;
  String? fcmToken;
  String? token;
  String? createdAt;

  Data({
    this.id,
    required this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.gender,
    this.image,
    this.fcmToken,
    this.token,
    this.createdAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? '',
        email = json['email'],
        countryCode = json['country_code'],
        phone = json['phone'],
        gender = json['gender'],
        image = json['image'],
        fcmToken = json['fcm_token'],
        token = json['token'],
        createdAt = json['created_at'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'country_code': countryCode,
        'phone': phone,
        'gender': gender,
        'image': image,
        'fcm_token': fcmToken,
        'token': token,
        'created_at': createdAt,
      };
}

class Links {
  String? first;
  String? last;
  Null? next;
  Null? prev;

  Links({this.first, this.last, this.next, this.prev});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    next = json['next'];
    prev = json['prev'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['next'] = this.next;
    data['prev'] = this.prev;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;

  Meta({this.currentPage, this.from, this.lastPage});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    return data;
  }
}