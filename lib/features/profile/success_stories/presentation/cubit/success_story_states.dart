
import '../../domain/entities/success_storie.dart';

abstract class SuccessStoryState {}

class SuccessStoryInitial extends SuccessStoryState {}
class SuccessStoryLoading extends SuccessStoryState {}
class SuccessStoryLoaded extends SuccessStoryState {
  final List<SuccessStoryEntity> stories;
  final int totalCount;
  SuccessStoryLoaded(this.stories, this.totalCount);
}
class SuccessStoryError extends SuccessStoryState {
  final String message;
  SuccessStoryError(this.message);
}
