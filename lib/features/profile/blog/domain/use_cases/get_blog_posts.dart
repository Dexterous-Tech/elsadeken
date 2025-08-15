import '../entities/blog_fetch_result.dart';
import '../repository/blog_repo.dart';

class GetBlogPosts {
  final BlogRepo repo;

  GetBlogPosts(this.repo);

  Future<BlogFetchResult> call() => repo.getBlogs();
}
/*
class GetBlogPostUseCase {
  final BlogRepository repository;

  const GetBlogPostUseCase(this.repository);

  Future<Either<Failure, BlogPost>> call(String id) async {
    return await repository.getBlogPost(id);
  }
}*/