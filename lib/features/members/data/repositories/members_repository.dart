import 'package:dio/dio.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/members/data/models/members.dart';
import '../models/api_response.dart';

class MembersRepository {
  Future<ApiResponse<Member>> getNewMembers({int? countryId}) async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.newMembers(countryId: countryId),
      requiresAuth: true,
    );
    return ApiResponse<Member>.fromJson(res.data, (e) => Member.fromJson(e));
  }

  Future<ApiResponse<Member>> getOnlineMembers() async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.onlineMembers,
      requiresAuth: true,
    );
    return ApiResponse<Member>.fromJson(res.data, (e) => Member.fromJson(e));
  }

  Future<ApiResponse<Member>> getDistinguishedMembers() async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.distinguishedMembers,
      requiresAuth: true,
    );
    return ApiResponse<Member>.fromJson(res.data, (e) => Member.fromJson(e));
  }

  Future<ApiResponse<Member>> getVisitors() async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.visitorsMembers,
      requiresAuth: true,
    );
    return ApiResponse<Member>.fromJson(res.data, (e) => Member.fromJson(e));
  }

  Future<ApiResponse<Member>> getHealthConditionMembers() async {
    final api = sl<ApiServices>();
    final Response res = await api.get(
      endpoint: ApiConstants.healthConditionMembers,
      requiresAuth: true,
    );
    return ApiResponse<Member>.fromJson(res.data, (e) => Member.fromJson(e));
  }
}
