import 'dart:developer';
import 'package:elsadeken/features/home/notification/data/model/notification_count_response_model.dart';
import 'package:elsadeken/features/home/notification/data/repo/notification_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'notification_count_state.dart';

class NotificationCountCubit extends Cubit<NotificationCountState> {
  NotificationCountCubit(this.notificationRepoInterface)
      : super(NotificationCountInitial());

  final NotificationRepoInterface notificationRepoInterface;

  void countNotification() async {
    log('NotificationCountCubit: Starting to count notifications...');
    emit(NotificationCountLoading());

    final response = await notificationRepoInterface.countNotification();

    response.fold(
      (failure) {
        log('NotificationCountCubit: Failed to count notifications - ${failure.displayMessage}');
        emit(NotificationCountFailure(failure.displayMessage));
      },
      (data) {
        log('NotificationCountCubit: Successfully counted notifications - ${data.data?.countUnreadNotifications ?? 0} unread');
        emit(NotificationCountSuccess(data));
      },
    );
  }

  // Convenience method to refresh notification count
  void refreshCount() {
    log('NotificationCountCubit: Refreshing notification count...');
    countNotification();
  }
}
