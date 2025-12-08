import 'package:elsadeken/features/home/notification/notification/data/model/notification_count_response_model.dart';
import 'package:elsadeken/features/home/notification/notification/data/repo/notification_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'notification_count_state.dart';

class NotificationCountCubit extends Cubit<NotificationCountState> {
  NotificationCountCubit(this.notificationRepoInterface)
      : super(NotificationCountInitial());

  final NotificationRepoInterface notificationRepoInterface;

  void countNotification() async {

    emit(NotificationCountLoading());

    final response = await notificationRepoInterface.countNotification();

    response.fold(
      (failure) {

        emit(NotificationCountFailure(failure.displayMessage));
      },
      (data) {

        emit(NotificationCountSuccess(data));
      },
    );
  }

  // Convenience method to refresh notification count
  void refreshCount() {

    countNotification();
  }
}
