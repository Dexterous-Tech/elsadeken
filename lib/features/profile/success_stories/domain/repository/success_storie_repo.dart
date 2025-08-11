import '../entities/success_storie.dart';

abstract class SuccessStoryRepository {
  Future<List<SuccessStoryEntity>> getStories();
}

