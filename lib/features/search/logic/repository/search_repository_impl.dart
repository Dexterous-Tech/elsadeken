import 'package:dio/dio.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository.dart';
import '../../domain/entities/search_filter.dart';
import '../../domain/entities/user_profile.dart';

class SearchRepositoryImpl implements SearchRepository {
  final Dio dio;

  SearchRepositoryImpl(this.dio);

  @override
  Future<List<UserProfile>> searchUsers(SearchFilter filter,
      {int page = 1}) async {
    try {
      // بيانات فلتر ثابتة مؤقتًا
      print(filter.toJson().toString());

      final response = await dio.post(
        "${ApiConstants.baseUrl}/user/search",
        data: filter,
        // data: {
        //   "user_name":"ahmed" //to be removed
        // },
      );

      if (response.statusCode == 200) {
        print("Search response: ${response.data}");
        final data = response.data;
        if (data['type'] == 'success') {
          return (data['data'] as List)
              .map((e) => UserProfile.fromJson(e))
              .toList();
        } else {
          throw Exception(data['message'] ?? "Search failed");
        }
      } else {
        throw Exception("Search failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("Search error: $e");
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
