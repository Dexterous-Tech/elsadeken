import '../../presentation/view/widgets/custom_searchable_list.dart';

class NationalCountryResponseModel with ListItemModel {
  NationalCountryResponseModel({
    this.id,
    this.name,
  });

  NationalCountryResponseModel.fromJson(dynamic json) {
    id = json['id'];
    name = _parseName(json['name']);
  }

  static String _parseName(dynamic nameData) {
    if (nameData is Map<String, dynamic>) {
      // New format with male/female names
      return nameData['male']?.toString() ??
          nameData['female']?.toString() ??
          '';
    } else if (nameData is String) {
      // Old format - single string
      return nameData;
    }
    return '';
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
