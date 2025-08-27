class MembersProfileResponseModel {
  MembersProfileResponseModel({
    this.data,
    this.links,
    this.meta,
    this.message,
    this.code,
    this.type,
  });

  MembersProfileResponseModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(MembersProfileDataModel.fromJson(v));
      });
    }
    links = json['links'] != null
        ? MembersProfileLinksModel.fromJson(json['links'])
        : null;
    meta = json['meta'] != null
        ? MembersProfileMetaModel.fromJson(json['meta'])
        : null;
    message = json['message'];
    code = json['code'];
    type = json['type'];
  }
  List<MembersProfileDataModel>? data;
  MembersProfileLinksModel? links;
  MembersProfileMetaModel? meta;
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

  MembersProfileResponseModel copyWith({
    List<MembersProfileDataModel>? data,
    MembersProfileLinksModel? links,
    MembersProfileMetaModel? meta,
    String? message,
    int? code,
    String? type,
  }) {
    return MembersProfileResponseModel(
      data: data ?? this.data,
      links: links ?? this.links,
      meta: meta ?? this.meta,
      message: message ?? this.message,
      code: code ?? this.code,
      type: type ?? this.type,
    );
  }
}

class MembersProfileAttributeModel {
  MembersProfileAttributeModel({
    this.id,
    this.city,
    this.country,
    this.maritalStatus,
    this.typeOfMarriage,
    this.age,
    this.children,
    this.weight,
    this.height,
    this.religiousCommitment,
    this.prayer,
    this.smoking,
    this.hijab,
    this.job,
    this.income,
    this.lifePartner,
    this.aboutMe,
  });

  MembersProfileAttributeModel.fromJson(dynamic json) {
    id = json['id'];
    city = json['city'];
    country = json['country'];
    maritalStatus = json['marital_status'];
    typeOfMarriage = json['type_of_marriage'];
    age = json['age'];
    children = json['children'];
    weight = json['weight'];
    height = json['height'];
    religiousCommitment = json['religious_commitment'];
    prayer = json['prayer'];
    smoking = json['smoking'];
    hijab = json['hijab'];
    job = json['job'];
    income = json['income'];
    lifePartner = json['life_partner'];
    aboutMe = json['about_me'];
  }
  int? id;
  String? city;
  String? country;
  String? maritalStatus;
  String? typeOfMarriage;
  int? age;
  int? children;
  int? weight;
  int? height;
  String? religiousCommitment;
  String? prayer;
  String? smoking;
  String? hijab;
  String? job;
  int? income;
  String? lifePartner;
  String? aboutMe;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['city'] = city;
    map['country'] = country;
    map['marital_status'] = maritalStatus;
    map['type_of_marriage'] = typeOfMarriage;
    map['age'] = age;
    map['children'] = children;
    map['weight'] = weight;
    map['height'] = height;
    map['religious_commitment'] = religiousCommitment;
    map['prayer'] = prayer;
    map['smoking'] = smoking;
    map['hijab'] = hijab;
    map['job'] = job;
    map['income'] = income;
    map['life_partner'] = lifePartner;
    map['about_me'] = aboutMe;
    return map;
  }
}

class MembersProfileDataModel {
  MembersProfileDataModel({
    this.id,
    this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.gender,
    this.image,
    this.fcmToken,
    this.token,
    this.isFeatured,
    this.createdAt,
    this.attribute,
  });

  MembersProfileDataModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    gender = json['gender'];
    image = json['image'];
    fcmToken = json['fcm_token'];
    token = json['token'];
    isFeatured = json['is_featured'];
    createdAt = json['created_at'];
    attribute = json['attribute'] != null
        ? MembersProfileAttributeModel.fromJson(json['attribute'])
        : null;
  }
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? phone;
  String? gender;
  String? image;
  dynamic fcmToken;
  dynamic token;
  int? isFeatured;
  String? createdAt;
  MembersProfileAttributeModel? attribute;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['phone'] = phone;
    map['gender'] = gender;
    map['image'] = image;
    map['fcm_token'] = fcmToken;
    map['token'] = token;
    map['is_featured'] = isFeatured;
    map['created_at'] = createdAt;
    if (attribute != null) {
      map['attribute'] = attribute?.toJson();
    }
    return map;
  }
}

class MembersProfileLinksModel {
  MembersProfileLinksModel({
    this.first,
    this.last,
    this.next,
    this.prev,
  });

  MembersProfileLinksModel.fromJson(dynamic json) {
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

class MembersProfileMetaModel {
  MembersProfileMetaModel({
    this.currentPage,
    this.from,
    this.lastPage,
  });

  MembersProfileMetaModel.fromJson(dynamic json) {
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
