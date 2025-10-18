import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/profile_details_action_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/profile_details_response_model.dart';

import '../../../../auth/signup/data/models/general_info_models.dart';

class ProfileDetailsDataSource {
  final ApiServices _apiServices;

  ProfileDetailsDataSource(this._apiServices);

  Future<ProfileDetailsActionResponseModel> ignoreUser(int userId) async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.ignoreUser(userId),
      requiresAuth: true,
    );

    return ProfileDetailsActionResponseModel.fromJson(response.data);
  }

  Future<ProfileDetailsActionResponseModel> likeUser(int userId) async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.likeUser(userId),
      requiresAuth: true,
    );

    return ProfileDetailsActionResponseModel.fromJson(response.data);
  }

  Future<ProfileDetailsResponseModel> getProfileDetails(int userId) async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.userDetails(userId),
      requiresAuth: true,
    );

    return ProfileDetailsResponseModel.fromJson(response.data);
  }

  Future<ProfileDetailsActionResponseModel> reportUser(
      int userId, int reasonId) async {
    var response = await _apiServices.get(
        endpoint: ApiConstants.reportUser(userId),
        requiresAuth: true,
        requestBody: {"report_reason_id": reasonId});

    return ProfileDetailsActionResponseModel.fromJson(response.data);
  }

  Future<ProfileDetailsActionResponseModel> shareUser(int userId) async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.shareUser(userId),
      requiresAuth: true,
    );

    return ProfileDetailsActionResponseModel.fromJson(response.data);
  }

  Future<List<GeneralInfoResponseModels>> getGeneralInfo(
      String endpoint) async {
    var response = await _apiServices.get(endpoint: endpoint);

    List<dynamic> jsonList = response.data;

    List<GeneralInfoResponseModels> generalList = jsonList
        .map((json) => GeneralInfoResponseModels.fromJson(json))
        .toList();
    return generalList;
  }
}
