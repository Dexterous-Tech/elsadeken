class SuccessStoryEntity {
  final int id;
  final String title;
  final String content;
  final String image;
  final DateTime createdAt;
  final int numberOfStories;

  SuccessStoryEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.createdAt,
    required this.numberOfStories,
  });
}
