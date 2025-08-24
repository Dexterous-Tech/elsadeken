part of 'update_profile_cubit.dart';

@immutable
sealed class UpdateProfileState {}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileLoginDataLoading extends UpdateProfileState {}

final class UpdateProfileLoginDataFailure extends UpdateProfileState {
  final String error;

  UpdateProfileLoginDataFailure(this.error);
}

final class UpdateProfileLoginDataSuccess extends UpdateProfileState {
  final MyProfileResponseModel myProfileResponseModel;

  UpdateProfileLoginDataSuccess(this.myProfileResponseModel);
}
