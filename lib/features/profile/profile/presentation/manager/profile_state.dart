part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class LogoutLoading extends ProfileState {}

final class LogoutFailure extends ProfileState {
  final String error;

  LogoutFailure(this.error);
}

final class LogoutSuccess extends ProfileState {
  final LogoutResponseModel logoutResponseModel;

  LogoutSuccess(this.logoutResponseModel);
}
