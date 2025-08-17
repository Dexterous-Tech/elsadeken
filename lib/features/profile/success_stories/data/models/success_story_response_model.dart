import '../../domain/entities/success_storie.dart';
import 'success_story_model.dart';
import 'package:flutter/foundation.dart';

class SuccessStoryResponseModel {
  final List<SuccessStoryEntity> data;
  final SuccessStoryMetaModel meta;
  final String message;
  final int code;
  final String type;
  final int? countStories;

  SuccessStoryResponseModel({
    required this.data,
    required this.meta,
    required this.message,
    required this.code,
    required this.type,
    this.countStories,
  });

  factory SuccessStoryResponseModel.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing response JSON: $json');
    
    List<SuccessStoryEntity> data = [];
    int? countStories;
    
    // Handle different data structures
    if (json['data'] is List) {
      // Original structure with list of stories
      final List<dynamic> dataList = json['data'] ?? [];
      data = dataList
          .map((item) => SuccessStoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (json['data'] is Map) {
      // New structure with count_stories in data object
      final dataMap = json['data'] as Map<String, dynamic>;
      countStories = dataMap['count_stories'];
      debugPrint('count_stories from data object: $countStories');
    }

    return SuccessStoryResponseModel(
      data: data,
      meta: SuccessStoryMetaModel.fromJson(json['meta'] ?? {}),
      message: json['message'] ?? '',
      code: json['code'] ?? json['status'] ?? 0,
      type: json['type'] ?? '',
      countStories: countStories,
    );
  }
}

class SuccessStoryMetaModel {
  final int currentPage;
  final int from;
  final int lastPage;
  final int? total;
  final int? countStories;

  SuccessStoryMetaModel({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    this.total,
    this.countStories,
  });

  factory SuccessStoryMetaModel.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing meta JSON: $json');
    final countStories = json['count_stories'] ?? json['count'];
    debugPrint('count_stories value: $countStories');
    debugPrint('count value: ${json['count']}');
    return SuccessStoryMetaModel(
      currentPage: json['current_page'] ?? 1,
      from: json['from'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'],
      countStories: countStories,
    );
  }
}
