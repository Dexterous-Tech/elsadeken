import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';

class IgnoreUserDataSource {
  final ApiServices _apiServices;

  IgnoreUserDataSource(this._apiServices);

  Future<UsersResponseModel> ignoreUsers({int? page}) async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.ignoreUserList,
      queryParameters: page != null ? {'page': page} : null,
    );

    return UsersResponseModel.fromJson(response.data);
  }
}
