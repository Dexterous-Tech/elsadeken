import 'package:elsadeken/features/success_stories/presentation/cubit/success_story_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_success_story.dart';


class SuccessStoryCubit extends Cubit<SuccessStoryState> {
  final GetSuccessStories getSuccessStories;

  SuccessStoryCubit(this.getSuccessStories) : super(SuccessStoryInitial());

  void loadStories() async {
    emit(SuccessStoryLoading());
    try {
      final stories = await getSuccessStories();
      emit(SuccessStoryLoaded(stories));
    } catch (e) {
      emit(SuccessStoryError('حدث خطأ أثناء تحميل القصص'));
    }
  }
}
