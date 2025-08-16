import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_blog_posts.dart';
import 'blog_states.dart';

class BlogCubit extends Cubit<BlogState> {
  final GetBlogPosts getBlogPosts;

  BlogCubit(this.getBlogPosts) : super(BlogInitial());

  void loadBlogs() async {
    emit(BlogLoading());
    try {
      final blogs = await getBlogPosts();
      emit(BlogLoaded(blogs));
    } catch (e) {
      emit(BlogError('فشل تحميل البيانات'));
    }
  }
}
