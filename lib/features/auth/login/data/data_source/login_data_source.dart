import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

import '../../../../../core/networking/api_constants.dart';
import '../../../../../core/networking/api_services.dart';
import '../models/login_models.dart';

class LoginDataSource {
  final ApiServices _apiServices;

  LoginDataSource(this._apiServices);

  Future<LoginResponseModel> login(
    LoginRequestBodyModel loginRequestBodyModel,
  ) async {
    var response = await _apiServices.post(
      endpoint: ApiConstants.login,
      requestBody: loginRequestBodyModel.toJson(),
      requiresAuth: false,
    );

    return LoginResponseModel.fromJson(response.data);
  }

  Future<ProfileActionResponseModel> updateFcm(
    String token,
  ) async {
    var response = await _apiServices.post(
      endpoint: ApiConstants.updateFcmToken,
      requestBody: {'fcm_token': token},
    );

    return ProfileActionResponseModel.fromJson(response.data);
  }
}
