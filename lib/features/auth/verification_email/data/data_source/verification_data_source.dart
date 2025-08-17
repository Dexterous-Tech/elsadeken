import '../../../../../core/networking/api_constants.dart';
import '../../../../../core/networking/api_services.dart';
import '../models/verification_models.dart';

class VerificationDataSource {
  final ApiServices _apiServices;

  VerificationDataSource(this._apiServices);

  Future<VerificationResponseModel> verifyOtp(
    VerificationRequestBodyModel verificationRequestBodyModel,
  ) async {
    var response = await _apiServices.post(
      endpoint: ApiConstants.verifyOtp,
      requestBody: verificationRequestBodyModel.toJson(),
      requiresAuth: false,
    );

    return VerificationResponseModel.fromJson(response.data);
  }
}
