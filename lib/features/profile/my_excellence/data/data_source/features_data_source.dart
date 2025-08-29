import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/my_excellence/data/models/features_model.dart';

class FeaturesDataSource {
  final ApiServices _apiServices;

  FeaturesDataSource(this._apiServices);

  Future<FeaturesModel> getFeatures() async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.getFeatures,
      requiresAuth: true,
    );

    return FeaturesModel.fromJson(response.data);
  }
}
