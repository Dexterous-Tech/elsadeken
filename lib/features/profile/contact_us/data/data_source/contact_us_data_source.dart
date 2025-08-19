import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/contact_us/data/models/contact_us_model.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

class ContactUsDataSource {
  final ApiServices _apiServices;

  ContactUsDataSource(this._apiServices);

  Future<ProfileActionResponseModel> contactUs(ContactUsModel contactUs) async {
    var response = await _apiServices.post(
        endpoint: ApiConstants.contactUs, requestBody: contactUs.toJson());

    return ProfileActionResponseModel.fromJson(response.data);
  }
}
