import 'package:dio/dio.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository.dart';
import 'package:elsadeken/features/search/domain/entities/search_filter.dart';

import '../../../profile/interests_list/data/models/users_response_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  final Dio dio;

  SearchRepositoryImpl(this.dio);

  @override
  Future<UsersResponseModel> searchUsers(
    SearchFilter filter, {
    int page = 1,
  }) async {
    try {
      final response = await dio.post(
        "${ApiConstants.baseUrl}/user/search",
        data: filter.toJson(page: page),
        // data: {
        //   "user_name":"ahmed" //to be removed
        // },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['type'] == 'success') {
          return UsersResponseModel.fromJson(data);
        } else {
          throw Exception(data['message'] ?? "Search failed");
        }
      } else {
        throw Exception("Search failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Search error: $e");
    }
  }

  @override
  Future<List<String>> getNationalities() async {
    await Future.delayed(Duration(milliseconds: 500));
    return ['مصري', 'سعودي', 'إماراتي', 'كويتي'];
  }

  @override
  Future<List<String>> getCountries() async {
    await Future.delayed(Duration(milliseconds: 500));
    return ['مصر', 'السعودية', 'الإمارات', 'الكويت'];
  }

  @override
  Future<List<String>> getCities() async {
    await Future.delayed(Duration(milliseconds: 500));
    return ['القاهرة', 'الإسكندرية', 'الجيزة', 'الرياض'];
  }
}
