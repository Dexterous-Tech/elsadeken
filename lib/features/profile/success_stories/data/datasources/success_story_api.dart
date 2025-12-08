// File: lib/features/blog/data/datasources/success_story_api.dart

import '../../domain/entities/success_storie.dart';
import '../models/success_story_model.dart';
import '../../../../../core/networking/api_services.dart';

class SuccessStoryApi {
  final ApiServices _apiServices;

  SuccessStoryApi(this._apiServices);

  Future<List<SuccessStoryEntity>> getStories() async {
    final response = await _apiServices.get(endpoint: '/user/success-stories');

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final decoded = response.data as Map<String, dynamic>;

      final List<dynamic> dataList = decoded['data'] ?? [];
      final stories = dataList
          .map(
            (item) => SuccessStoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return stories;
    }

    return <SuccessStoryEntity>[];
  }

  Future<int> getStoriesCount() async {
    final response = await _apiServices.get(
      endpoint: '/user/success-stories/details',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final decoded = response.data as Map<String, dynamic>;

      if (decoded['data'] is Map) {
        final dataMap = decoded['data'] as Map<String, dynamic>;
        final count = dataMap['count_stories'] ?? 0;
        return count;
      }
    }

    return 0;
  }
}
