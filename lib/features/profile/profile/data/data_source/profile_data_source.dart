import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

class ProfileDataSource {
  final ApiServices _apiServices;

  ProfileDataSource(this._apiServices);

  Future<LogoutResponseModel> logout() async {
    var response = await _apiServices.post(
        endpoint: ApiConstants.logout, requestBody: null);

    return LogoutResponseModel.fromJson(response.data);
  }
}
