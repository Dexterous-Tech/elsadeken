import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_fetch_result.dart';

abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLoaded extends BlogState {
  final List<Blog> blogs;
  final int? httpStatusCode;
  final int? apiCode;

  BlogLoaded(BlogFetchResult result)
      : blogs = result.blogs,
        httpStatusCode = result.httpStatusCode,
        apiCode = result.apiCode;
}

class BlogError extends BlogState {
  final String message;
  BlogError(this.message);
}
