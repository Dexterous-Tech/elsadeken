import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/like_user_model.dart';

class LikeUserDataSource {
  final ApiServices _apiServices;

  LikeUserDataSource(this._apiServices);

  Future<LikeUserResponseModel> likeUser(String userId) async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.likeUser(userId),
      requiresAuth: true,
    );

    return LikeUserResponseModel.fromJson(response.data);
  }
}
