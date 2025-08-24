part of 'notification_count_cubit.dart';

@immutable
sealed class NotificationCountState {}

final class NotificationCountInitial extends NotificationCountState {}

final class NotificationCountLoading extends NotificationCountState {}

final class NotificationCountFailure extends NotificationCountState {
  final String error;

  NotificationCountFailure(this.error);
}

final class NotificationCountSuccess extends NotificationCountState {
  final NotificationCountResponseModel notificationCountResponseModel;

  NotificationCountSuccess(this.notificationCountResponseModel);
}
