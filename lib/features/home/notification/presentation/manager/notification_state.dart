part of 'notification_cubit.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationPaginationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<NotificationModel> notifications;
  final bool hasNextPage;
  final int currentPage;

  NotificationSuccess({
    required this.notifications,
    required this.hasNextPage,
    required this.currentPage,
  });
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
