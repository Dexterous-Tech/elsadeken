part of 'manage_profile_cubit.dart';

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


final class DeleteProfileLoading extends ManageProfileState {}
final class DeleteProfileFailure extends ManageProfileState {
  final String error ;

  DeleteProfileFailure(this.error);
}
final class DeleteProfileSuccess extends ManageProfileState {
  final ProfileActionResponseModel profileActionResponseModel;

  DeleteProfileSuccess(this.profileActionResponseModel);
}
