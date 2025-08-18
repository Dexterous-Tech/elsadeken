import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

class ManageProfileDataSource {
  final ApiServices _apiServices;

  ManageProfileDataSource(this._apiServices);

  Future<MyProfileResponseModel> getProfile() async {
    var response = await _apiServices.get(endpoint: ApiConstants.getProfile);

    return MyProfileResponseModel.fromJson(response.data);
  }
  
  Future<ProfileActionResponseModel> deleteAccount() async{

  var response = await _apiServices.delete(endpoint: ApiConstants.deleteUser);

  return ProfileActionResponseModel.fromJson(response.data);
  
  }
}
