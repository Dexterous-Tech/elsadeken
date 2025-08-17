import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/fav_user_list.dart';

class FavUserDataSource {
  final ApiServices _apiServices;

  FavUserDataSource(this._apiServices);

  Future<FavUserListModel> favUsers() async {
    var response =
        await _apiServices.get(endpoint: ApiConstants.favUserList);

    return FavUserListModel.fromJson(response.data);
  }
}
