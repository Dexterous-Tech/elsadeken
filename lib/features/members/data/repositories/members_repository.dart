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

  Future<UsersResponseModel> getDistinguishedMembers({
    String? countryName,
  }) async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.distinguishedMembers,
      requiresAuth: true,
    );
    final response = UsersResponseModel.fromJson(res.data);

    // If countryName is provided, filter the results on the client side
    if (countryName != null &&
        countryName.isNotEmpty &&
        countryName != 'all' &&
        response.data != null) {
      // Debug: Print all unique countries in the data
      // final uniqueCountries =
      //     response.data!.map((user) => user.attribute?.country).toSet();

      final filteredData = response.data!.where((user) {
        final userCountry = user.attribute?.country?.toLowerCase();
        final match = userCountry == countryName.toLowerCase();
        if (match) {}
        return match;
      }).toList();

      // Create a new response with filtered data
      return UsersResponseModel(
        data: filteredData,
        links: response.links,
        meta: response.meta,
        message: response.message,
        code: response.code,
        type: response.type,
      );
    }

    return response;
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
