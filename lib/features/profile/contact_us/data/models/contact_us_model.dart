class ContactUsModel {
  ContactUsModel({
    this.email,
    this.title,
    this.description,
  });

  ContactUsModel.fromJson(dynamic json) {
    email = json['email'];
    title = json['title'];
    description = json['description'];
  }
  String? email;
  String? title;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['title'] = title;
    map['description'] = description;
    return map;
  }
}
