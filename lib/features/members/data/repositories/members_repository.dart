import 'package:dio/dio.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import '../../../profile/interests_list/data/models/users_response_model.dart';

class MembersRepository {
  Future<UsersResponseModel> getNewMembers({int? countryId}) async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.newMembers(countryId: countryId),
      requiresAuth: true,
    );
    return UsersResponseModel.fromJson(res.data);
  }

  Future<UsersResponseModel> getOnlineMembers() async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.onlineMembers,
      requiresAuth: true,
    );

    return UsersResponseModel.fromJson(res.data);
  }

  Future<UsersResponseModel> getDistinguishedMembers({String? countryName}) async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.distinguishedMembers,
      requiresAuth: true,
    );
    final response = UsersResponseModel.fromJson(res.data);
    
    print('🔍 Premium Members Repository - countryName: $countryName');
    print('🔍 Premium Members Repository - total members before filter: ${response.data?.length ?? 0}');
    
    // If countryName is provided, filter the results on the client side
    if (countryName != null && countryName.isNotEmpty && countryName != 'all' && response.data != null) {
      print('🔍 Premium Members Repository - filtering by country: $countryName');
      
      // Debug: Print all unique countries in the data
      final uniqueCountries = response.data!.map((user) => user.attribute?.country).toSet();
      print('🔍 Premium Members Repository - unique countries in data: $uniqueCountries');
      
      final filteredData = response.data!.where((user) {
        final userCountry = user.attribute?.country?.toLowerCase();
        final match = userCountry == countryName.toLowerCase();
        if (match) {
          print('🔍 Premium Members Repository - matched user: ${user.name} from ${user.attribute?.country}');
        }
        return match;
      }).toList();
      
      print('🔍 Premium Members Repository - filtered members count: ${filteredData.length}');
      
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
    
    print('🔍 Premium Members Repository - no filtering applied, returning all data');
    return response;
  }

  Future<UsersResponseModel> getVisitors() async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.visitorsMembers,
      requiresAuth: true,
    );
    return UsersResponseModel.fromJson(res.data);
  }

  Future<UsersResponseModel> getHealthConditionMembers() async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.healthConditionMembers,
      requiresAuth: true,
    );
    return UsersResponseModel.fromJson(res.data);
  }
}
