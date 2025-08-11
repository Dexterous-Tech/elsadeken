
import '../../domain/entities/success_storie.dart';

class SuccessStoryModel extends SuccessStoryEntity {
  SuccessStoryModel({
    required super.name,
    required super.age,
    required super.message,
  });

  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryModel(
      name: json['name'],
      age: json['age'],
      message: json['message'],
    );
  }
}
