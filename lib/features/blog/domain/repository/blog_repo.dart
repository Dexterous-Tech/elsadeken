import '../entities/blog.dart';

abstract class BlogRepo {
  Future<List<Blog>> getBlogs();
}
//Future<Either<Failure, BlogPost>> getBlogPost(String id);