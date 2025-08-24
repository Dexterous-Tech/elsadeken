class UpdateProfileLoginDataRequestModel {
  UpdateProfileLoginDataRequestModel({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.passwordConfirmation,
  });

  UpdateProfileLoginDataRequestModel.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }
  String? name;
  String? email;
  String? phone;
  String? password;
  String? passwordConfirmation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['password'] = password;
    map['password_confirmation'] = passwordConfirmation;
    return map;
  }
}
