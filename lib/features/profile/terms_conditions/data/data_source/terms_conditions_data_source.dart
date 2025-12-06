import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/about_us/data/models/about_us_model.dart';

class TermsConditionsDataSource {
  final ApiServices _apiServices;

  TermsConditionsDataSource(this._apiServices);

  Future<AboutUsResponseModel> termsConditions() async {
    var response =
        await _apiServices.get(endpoint: ApiConstants.termsConditions);

    return AboutUsResponseModel.fromJson(response.data);
  }
}
