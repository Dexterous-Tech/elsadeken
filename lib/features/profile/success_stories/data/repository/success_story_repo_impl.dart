import '../../domain/entities/success_storie.dart';
import '../../domain/repository/success_storie_repo.dart';
import '../models/success_story_model.dart';

class SuccessStoryRepositoryImpl implements SuccessStoryRepository {
  @override
  Future<List<SuccessStoryEntity>> getStories() async {
    // Simulate API response
    await Future.delayed(Duration(seconds: 1));
    return [
      SuccessStoryModel(
        name: 'بدرى محمد',
        age: 46,
        message: 'شكرًا للموقع الذي كان له الفضل ...شكرًا للموقع الذي كان له الفضل ...شكرًا للموقع الذي كان له الفضل ...شكرًا للموقع الذي كان له الفضل ...شكرًا للموقع الذي كان له الفضل ...',
      ),
      SuccessStoryModel(
        name: 'بدرى محمد',
        age: 46,
        message: 'شكرًا للموقع الذي كان له الفضل ...',
      ),
    ];
  }
}
