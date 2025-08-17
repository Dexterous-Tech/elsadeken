import '../../presentation/view/widgets/custom_searchable_list.dart';

class NationalCountryResponseModel with ListItemModel {
  NationalCountryResponseModel({
    this.id,
    this.name,
  });

  NationalCountryResponseModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  @override
  int? id;
  @override
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
