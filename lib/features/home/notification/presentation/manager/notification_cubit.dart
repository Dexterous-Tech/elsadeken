import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/home/notification/data/model/notification_model.dart';
import 'package:elsadeken/features/home/notification/data/repo/notification_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.notificationRepoInterface)
      : super(NotificationInitial());

  final NotificationRepoInterface notificationRepoInterface;

  Future<void> getNotifications({int? page}) async {
    try {
      if (page == 1 || page == null) {
        emit(NotificationLoading());
      } else {
        emit(NotificationPaginationLoading());
      }

      final result =
          await notificationRepoInterface.getNotifications(page: page);

      if (page == 1 || page == null) {
        emit(NotificationSuccess(
          notifications: result.notifications,
          hasNextPage: result.hasNextPage,
          currentPage: result.currentPage,
        ));
      } else {
        final currentState = state;
        if (currentState is NotificationSuccess) {
          final updatedNotifications = [
            ...currentState.notifications,
            ...result.notifications
          ];
          emit(NotificationSuccess(
            notifications: updatedNotifications,
            hasNextPage: result.hasNextPage,
            currentPage: result.currentPage,
          ));
        }
      }
    } on ApiErrorModel catch (error) {
      emit(NotificationError(error.displayMessage));
    } catch (e) {
      emit(NotificationError('An unexpected error occurred: $e'));
    }
  }

  void resetState() {
    emit(NotificationInitial());
  }
}
