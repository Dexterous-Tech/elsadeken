import '../../domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.imageUrl,
    required super.title,
    required super.content,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      imageUrl: json['imageUrl'],
      title: json['title'],
      content: json['content'],
    );
  }
}
