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

  Future<UsersResponseModel> getDistinguishedMembers() async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.distinguishedMembers,
      requiresAuth: true,
    );
    return UsersResponseModel.fromJson(res.data);
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
