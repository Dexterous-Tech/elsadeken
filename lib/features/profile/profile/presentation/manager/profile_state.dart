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
  final ProfileActionResponseModel logoutResponseModel;

  LogoutSuccess(this.logoutResponseModel);
}

final class DeleteImageLoading extends ProfileState {}

final class DeleteImageFailure extends ProfileState {
  final String error;

  DeleteImageFailure(this.error);
}

final class DeleteImageSuccess extends ProfileState {
  final ProfileActionResponseModel logoutResponseModel;

  DeleteImageSuccess(this.logoutResponseModel);
}
