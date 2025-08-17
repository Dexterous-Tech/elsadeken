import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/like_user_model.dart';

class IgnoreUserDataSource {
  final ApiServices _apiServices;

  IgnoreUserDataSource(this._apiServices);

  Future<LikeUserResponseModel> ignoreUser(String userId) async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.ignoreUser(userId),
      requiresAuth: true,
    );

    return LikeUserResponseModel.fromJson(response.data);
  }
}
