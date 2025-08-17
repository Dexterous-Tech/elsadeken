import 'package:elsadeken/features/profile/success_stories/presentation/cubit/success_story_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../domain/use_cases/get_success_story.dart';

class SuccessStoryCubit extends Cubit<SuccessStoryState> {
  final GetSuccessStories getSuccessStories;

  SuccessStoryCubit(this.getSuccessStories) : super(SuccessStoryInitial());

  void loadStories() async {
    emit(SuccessStoryLoading());
    try {
      final stories = await getSuccessStories();
      final count = await getSuccessStories.callCount();
      
      debugPrint('Total count being passed to UI: $count');
      emit(SuccessStoryLoaded(stories, count));
    } catch (e) {
      debugPrint('Error loading stories: $e');
      emit(SuccessStoryError('حدث خطأ أثناء تحميل القصص'));
    }
  }
} 
