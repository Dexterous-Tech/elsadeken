import '../entities/blog_fetch_result.dart';

abstract class BlogRepo {
  Future<BlogFetchResult> getBlogs();
}
//Future<Either<Failure, BlogPost>> getBlogPost(String id);