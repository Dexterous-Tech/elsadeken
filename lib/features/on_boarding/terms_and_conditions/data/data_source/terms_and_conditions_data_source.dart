import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/data/models/terms_and_conditions_model.dart';

class TermsAndConditionsDataSource{

  final ApiServices _apiServices;

  TermsAndConditionsDataSource(this._apiServices);

  Future<TermsAndConditionsResponseModel> getTermsAndConditions()async{
    var response = await _apiServices.get(endpoint: ApiConstants.aboutUs);

    return TermsAndConditionsResponseModel.fromJson(response.data);
  }
}
