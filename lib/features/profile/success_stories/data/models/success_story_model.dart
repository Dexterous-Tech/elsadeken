
import '../../domain/entities/success_storie.dart';

class SuccessStoryModel extends SuccessStoryEntity {
  SuccessStoryModel({
    required super.id,
    required super.title,
    required super.content,
    required super.image,
    required super.createdAt,
    required super.numberOfStories,
  });

  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['crated_at'] != null 
          ? DateTime.parse(json['crated_at']) 
          : DateTime.now(),
      numberOfStories: json['number_of_stories'] ?? 0,
    );
  }
}
