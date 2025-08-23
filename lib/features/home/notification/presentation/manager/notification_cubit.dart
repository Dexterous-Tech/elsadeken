import 'dart:developer';

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
        log('Loading initial notifications...');
        emit(NotificationLoading());
      } else {
        log('Loading more notifications for page $page...');
        // Don't emit loading state for pagination to keep existing data visible
        // We'll handle pagination loading in the UI
      }

      final result =
          await notificationRepoInterface.getNotifications(page: page);

      if (page == 1 || page == null) {
        log('Initial notifications loaded: ${result.notifications.length} items');
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
          log('Pagination completed: Added ${result.notifications.length} items, total: ${updatedNotifications.length}');
          emit(NotificationSuccess(
            notifications: updatedNotifications,
            hasNextPage: result.hasNextPage,
            currentPage: result.currentPage,
          ));
        }
      }
    } on ApiErrorModel catch (error) {
      log('Error loading notifications: ${error.displayMessage}');
      emit(NotificationError(error.displayMessage));
    } catch (e) {
      log('Unexpected error loading notifications: $e');
      emit(NotificationError('An unexpected error occurred: $e'));
    }
  }

  void resetState() {
    emit(NotificationInitial());
  }
}
