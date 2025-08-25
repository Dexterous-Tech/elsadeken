import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';

class FavUserDataSource {
  final ApiServices _apiServices;

  FavUserDataSource(this._apiServices);

  Future<UsersResponseModel> favUsers({int? page}) async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.favUserList,
      queryParameters: page != null ? {'page': page} : null,
    );

    return UsersResponseModel.fromJson(response.data);
  }
}
