part of 'manage_profile_cubit.dart';

@immutable
sealed class ManageProfileState {}

final class ManageProfileInitial extends ManageProfileState {}

final class ManageProfileLoading extends ManageProfileState {}

final class ManageProfileSuccess extends ManageProfileState {
  final MyProfileResponseModel myProfileResponseModel;

  ManageProfileSuccess(this.myProfileResponseModel);
}

final class ManageProfileFailure extends ManageProfileState {
  final String error;

  ManageProfileFailure(this.error);
}
