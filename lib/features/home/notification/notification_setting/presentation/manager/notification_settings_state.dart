part of 'notification_settings_cubit.dart';

abstract class NotificationSettingsState {}

class NotificationSettingsInitial extends NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final List<Map<String, dynamic>> settings;

  NotificationSettingsLoaded({required this.settings});
}

class NotificationSettingsError extends NotificationSettingsState {
  final String message;

  NotificationSettingsError(this.message);
}

class NotificationSettingsSuccess extends NotificationSettingsState {
  final String message;
  final List<Map<String, dynamic>> settings;

  NotificationSettingsSuccess({
    required this.message,
    required this.settings,
  });
}
