
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_fetch_result.dart';
import '../../domain/repository/blog_repo.dart';
import '../models/blog_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BlogApi implements BlogRepo {
  final Dio _dio;

  BlogApi(this._dio);

  @override
  Future<BlogFetchResult> getBlogs() async {
    final response = await _dio.get('/user/blogs');
    debugPrint('GET /user/blogs -> HTTP ${response.statusCode}');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final decoded = response.data as Map<String, dynamic>;
      if (decoded.containsKey('code')) {
        debugPrint('API payload code: ${decoded['code']}');
      }
      final List<dynamic> data = decoded['data'] ?? [];
      final blogs = data
          .map((item) => BlogModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return BlogFetchResult(
        blogs: blogs,
        httpStatusCode: response.statusCode,
        apiCode: decoded['code'] is int ? decoded['code'] as int : null,
      );
    }

    return BlogFetchResult(
      blogs: const <Blog>[],
      httpStatusCode: response.statusCode,
      apiCode: null,
    );
  }
}
