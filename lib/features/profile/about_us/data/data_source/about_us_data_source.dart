import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/about_us/data/models/about_us_model.dart';

class AboutUsDataSource{

  final ApiServices _apiServices;

  AboutUsDataSource(this._apiServices);

  Future<AboutUsResponseModel> aboutUs()async{
    var response = await _apiServices.get(endpoint: ApiConstants.aboutUs);

    return AboutUsResponseModel.fromJson(response.data);
  }
}