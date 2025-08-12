import '../../../../../core/networking/api_constants.dart';
import '../../../../../core/networking/api_services.dart';
import '../models/reset_password_models.dart';

class ResetPasswordDataSource {
  final ApiServices _apiServices;

  ResetPasswordDataSource(this._apiServices);

  Future<ResetPasswordResponseModel> resetPassword(
      ResetPasswordRequestBodyModel resetPasswordRequestBodyModel,
  ) async {
    var response = await _apiServices.post(
      endpoint: ApiConstants.resetPassword,
      requestBody: resetPasswordRequestBodyModel.toJson(),
      requiresAuth: false,
    );

    return ResetPasswordResponseModel.fromJson(response.data);
  }
}
