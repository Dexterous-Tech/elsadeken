// File: lib/features/blog/data/datasources/success_story_api.dart

import '../../domain/entities/success_storie.dart';
import '../../domain/repository/success_storie_repo.dart';
import '../models/success_story_model.dart';

class  SuccessStoryApi{
  @override
  Future<List<SuccessStoryEntity>> getStories() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    return [
      SuccessStoryModel(name: 'Ahmed', age: 21, message: 'thanksthanksthanksthanksthanksthanksthanksthanksthanksthanksthanks'),


    ];
  }
}
/*
import 'package:dio/dio.dart';
import '../models/success_story_model.dart';

abstract class SuccessStoriesApi {
  Future<List<SuccessStoryModel>> getSuccessStories();
}

class SuccessStoriesApiImpl implements SuccessStoriesApi {
  final Dio dio;

  SuccessStoriesApiImpl(this.dio);

  @override
  Future<List<SuccessStoryModel>> getSuccessStories() async {
    final response = await dio.get("https://api.example.com/success_stories");
    return (response.data as List)
        .map((json) => SuccessStoryModel.fromJson(json))
        .toList();
  }
}
*/