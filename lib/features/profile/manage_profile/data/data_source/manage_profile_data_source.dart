import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/update_profile_models.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

class ManageProfileDataSource {
  final ApiServices _apiServices;

  ManageProfileDataSource(this._apiServices);

  Future<MyProfileResponseModel> getProfile() async {
    var response = await _apiServices.get(endpoint: ApiConstants.getProfile);

    return MyProfileResponseModel.fromJson(response.data);
  }

  Future<ProfileActionResponseModel> deleteAccount() async {
    var response = await _apiServices.delete(endpoint: ApiConstants.deleteUser);

    return ProfileActionResponseModel.fromJson(response.data);
  }

  Future<MyProfileResponseModel> updateProfileLoginData(
      UpdateProfileLoginDataRequestModel updateProfileData) async {
    var response = await _apiServices.patch(
        endpoint: ApiConstants.updateProfileLoginData,
        requestBody: updateProfileData.toJson());

    return MyProfileResponseModel.fromJson(response.data);
  }

  Future<MyProfileResponseModel> updateProfileLocationData(
      UpdateProfileLocationDataModel updateProfileData) async {
    var response = await _apiServices.patch(
        endpoint: ApiConstants.updateProfileLocationData,
        requestBody: updateProfileData.toJson());

    return MyProfileResponseModel.fromJson(response.data);
  }

  Future<MyProfileResponseModel> updateProfileMarriageData(
      UpdateProfileMarriageDataModel updateProfileData) async {
    var response = await _apiServices.patch(
        endpoint: ApiConstants.updateProfileMarriageData,
        requestBody: updateProfileData.toJson());

    return MyProfileResponseModel.fromJson(response.data);
  }

  Future<MyProfileResponseModel> updateProfilePhysicalData(
      UpdateProfilePhysicalDataModel updateProfileData) async {
    var response = await _apiServices.patch(
        endpoint: ApiConstants.updateProfilePhysicsData,
        requestBody: updateProfileData.toJson());

    return MyProfileResponseModel.fromJson(response.data);
  }

  Future<MyProfileResponseModel> updateProfileWorkData(
      UpdateProfileWorkDataModel updateProfileData) async {
    var response = await _apiServices.patch(
        endpoint: ApiConstants.updateProfileWorkingData,
        requestBody: updateProfileData.toJson());

    return MyProfileResponseModel.fromJson(response.data);
  }

  Future<MyProfileResponseModel> updateProfileAboutMeData(
      UpdateProfileAboutMeDataModel updateProfileData) async {
    var response = await _apiServices.patch(
        endpoint: ApiConstants.updateProfileAboutMeData,
        requestBody: updateProfileData.toJson());

    return MyProfileResponseModel.fromJson(response.data);
  }

  Future<MyProfileResponseModel> updateProfileAboutPartnerData(
      UpdateProfileAboutPartnerDataModel updateProfileData) async {
    var response = await _apiServices.patch(
        endpoint: ApiConstants.updateProfileAboutPartnerData,
        requestBody: updateProfileData.toJson());

    return MyProfileResponseModel.fromJson(response.data);
  }
}
