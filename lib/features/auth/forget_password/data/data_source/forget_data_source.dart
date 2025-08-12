import '../../../../../core/networking/api_constants.dart';
import '../../../../../core/networking/api_services.dart';
import '../models/forget_models.dart';

class ForgetDataSource {
  final ApiServices _apiServices;

  ForgetDataSource(this._apiServices);

  Future<ForgetResponseModel> forgetPassword(
    ForgetRequestBodyModel forgetRequestBodyModel,
  ) async {
    var response = await _apiServices.post(
      endpoint: ApiConstants.forgetPassword,
      requestBody: forgetRequestBodyModel.toJson(),
      requiresAuth: false,
    );

    return ForgetResponseModel.fromJson(response.data);
  }
}
