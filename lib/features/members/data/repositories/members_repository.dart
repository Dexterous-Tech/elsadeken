import 'package:dio/dio.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import '../../../profile/interests_list/data/models/users_response_model.dart';

class MembersRepository {
  Future<UsersResponseModel> getNewMembers({int? countryId, int? page}) async {
    final api = sl<ApiServices>();

    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (countryId != null) {
      queryParams['country_id'] = countryId;
    }
    if (page != null) {
      queryParams['page'] = page;
    }

    final Response res = await api.get(
      endpoint: ApiConstants.newMembers(countryId: countryId),
      requiresAuth: true,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return UsersResponseModel.fromJson(res.data);
  }

  Future<UsersResponseModel> getOnlineMembers({int? page}) async {
    final api = sl<ApiServices>();

    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (page != null) {
      queryParams['page'] = page;
    }

    final Response res = await api.get(
      endpoint: ApiConstants.onlineMembers,
      requiresAuth: true,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    return UsersResponseModel.fromJson(res.data);
  }

  Future<UsersResponseModel> getDistinguishedMembers({int? page}) async {
    final api = sl<ApiServices>();

    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (page != null) {
      queryParams['page'] = page;
    }

    final Response res = await api.get(
      endpoint: ApiConstants.distinguishedMembers,
      requiresAuth: true,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return UsersResponseModel.fromJson(res.data);
  }

  Future<UsersResponseModel> getVisitors({int? page}) async {
    final api = sl<ApiServices>();

    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (page != null) {
      queryParams['page'] = page;
    }

    final Response res = await api.get(
      endpoint: ApiConstants.visitorsMembers,
      requiresAuth: true,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return UsersResponseModel.fromJson(res.data);
  }

  Future<UsersResponseModel> getHealthConditionMembers({
    int? healthConditionId,
    int? countryId,
    int? page,
  }) async {
    final api = sl<ApiServices>();

    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (healthConditionId != null) {
      queryParams['health_condition_id'] = healthConditionId;
    }
    if (countryId != null) {
      queryParams['country_id'] = countryId;
    }
    if (page != null) {
      queryParams['page'] = page;
    }

    final Response res = await api.get(
      endpoint: ApiConstants.healthConditionMembers,
      requiresAuth: true,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return UsersResponseModel.fromJson(res.data);
  }
}
