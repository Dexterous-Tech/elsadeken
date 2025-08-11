// lib/features/blog/data/repositories/success_story_repo_impl.dart
import '../../domain/entities/blog.dart';
import '../../domain/repository/blog_repo.dart';
import '../datasources/blog_api.dart';

class BlogRepoImpl implements BlogRepo {
  final BlogApi api;

  BlogRepoImpl(this.api);

  @override
  Future<List<Blog>> getBlogs() async {
    final blogs = await api.getBlogs();
    return blogs; // Models already extend Blog entity
  }
}
