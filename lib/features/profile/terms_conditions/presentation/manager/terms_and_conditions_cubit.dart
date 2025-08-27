import 'package:elsadeken/features/profile/terms_conditions/presentation/manager/terms_and_conditions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_blog_posts.dart';

class TermsCubit extends Cubit<TermsState> {
  final GetBlogPosts getBlogPosts;

  TermsCubit(this.getBlogPosts) : super(TermsInitial());

  static TermsCubit get(context) => BlocProvider.of<TermsCubit>(context);

  void loadTerms() async {
    emit(TermsLoading());
    try {
      final result = await getBlogPosts();
      emit(TermsLoaded(result));
    } catch (e) {
      emit(TermsError('فشل تحميل البيانات'));
    }
  }
}
