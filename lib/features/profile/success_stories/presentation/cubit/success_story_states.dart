
import '../../domain/entities/success_storie.dart';

abstract class SuccessStoryState {}

class SuccessStoryInitial extends SuccessStoryState {}
class SuccessStoryLoading extends SuccessStoryState {}
class SuccessStoryLoaded extends SuccessStoryState {
  final List<SuccessStoryEntity> stories;
  SuccessStoryLoaded(this.stories);
}
class SuccessStoryError extends SuccessStoryState {
  final String message;
  SuccessStoryError(this.message);
}
