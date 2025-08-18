import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';

class ProfileDetailsResponseModel {
  final UsersDataModel? data;

  ProfileDetailsResponseModel({this.data});

  ProfileDetailsResponseModel.fromJson(dynamic json)
      : data =
            json['data'] != null ? UsersDataModel.fromJson(json['data']) : null;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.toJson(); // ✅ keep the same key as fromJson
    }
    return map;
  }
}
