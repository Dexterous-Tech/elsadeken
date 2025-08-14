import 'blog.dart';

class BlogFetchResult {
  final List<Blog> blogs;
  final int? httpStatusCode;
  final int? apiCode;

  const BlogFetchResult({
    required this.blogs,
    this.httpStatusCode,
    this.apiCode,
  });
}


