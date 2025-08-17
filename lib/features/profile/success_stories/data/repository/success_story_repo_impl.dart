import '../../domain/entities/success_storie.dart';
import '../../domain/repository/success_storie_repo.dart';
import '../models/success_story_model.dart';
import '../datasources/success_story_api.dart';
import '../../../../../core/networking/api_services.dart';

class SuccessStoryRepositoryImpl implements SuccessStoryRepository {
  final SuccessStoryApi api;

  SuccessStoryRepositoryImpl(this.api);

  @override
  Future<List<SuccessStoryEntity>> getStories() async {
    return api.getStories();
  }

  @override
  Future<int> getStoriesCount() async {
    return api.getStoriesCount();
  }

  factory SuccessStoryRepositoryImpl.create(ApiServices apiServices) {
    final api = SuccessStoryApi(apiServices);
    return SuccessStoryRepositoryImpl(api);
  } 
}
