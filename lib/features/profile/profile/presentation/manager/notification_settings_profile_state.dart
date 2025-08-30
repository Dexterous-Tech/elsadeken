part of 'notification_settings_profile_cubit.dart';

abstract class NotificationSettingsProfileState {}

class NotificationSettingsProfileInitial
    extends NotificationSettingsProfileState {}

class NotificationSettingsProfileLoading
    extends NotificationSettingsProfileState {}

class NotificationSettingsProfileLoaded
    extends NotificationSettingsProfileState {
  final bool isEnabled;

  NotificationSettingsProfileLoaded({required this.isEnabled});
}

class NotificationSettingsToggleSuccess
    extends NotificationSettingsProfileState {
  final bool isEnabled;
  final String message;

  NotificationSettingsToggleSuccess(
      {required this.isEnabled, required this.message});
}

class NotificationSettingsError extends NotificationSettingsProfileState {
  final String message;

  NotificationSettingsError(this.message);
}
