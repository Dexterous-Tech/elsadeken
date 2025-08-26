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

// Location Data States
final class UpdateProfileLocationDataLoading extends UpdateProfileState {}

final class UpdateProfileLocationDataFailure extends UpdateProfileState {
  final String error;
  UpdateProfileLocationDataFailure(this.error);
}

final class UpdateProfileLocationDataSuccess extends UpdateProfileState {
  final MyProfileResponseModel myProfileResponseModel;
  UpdateProfileLocationDataSuccess(this.myProfileResponseModel);
}

// Marriage Data States
final class UpdateProfileMarriageDataLoading extends UpdateProfileState {}

final class UpdateProfileMarriageDataFailure extends UpdateProfileState {
  final String error;
  UpdateProfileMarriageDataFailure(this.error);
}

final class UpdateProfileMarriageDataSuccess extends UpdateProfileState {
  final MyProfileResponseModel myProfileResponseModel;
  UpdateProfileMarriageDataSuccess(this.myProfileResponseModel);
}

// Physical Data States
final class UpdateProfilePhysicalDataLoading extends UpdateProfileState {}

final class UpdateProfilePhysicalDataFailure extends UpdateProfileState {
  final String error;
  UpdateProfilePhysicalDataFailure(this.error);
}

final class UpdateProfilePhysicalDataSuccess extends UpdateProfileState {
  final MyProfileResponseModel myProfileResponseModel;
  UpdateProfilePhysicalDataSuccess(this.myProfileResponseModel);
}

// Work Data States
final class UpdateProfileWorkDataLoading extends UpdateProfileState {}

final class UpdateProfileWorkDataFailure extends UpdateProfileState {
  final String error;
  UpdateProfileWorkDataFailure(this.error);
}

final class UpdateProfileWorkDataSuccess extends UpdateProfileState {
  final MyProfileResponseModel myProfileResponseModel;
  UpdateProfileWorkDataSuccess(this.myProfileResponseModel);
}

// About Me Data States
final class UpdateProfileAboutMeDataLoading extends UpdateProfileState {}

final class UpdateProfileAboutMeDataFailure extends UpdateProfileState {
  final String error;
  UpdateProfileAboutMeDataFailure(this.error);
}

final class UpdateProfileAboutMeDataSuccess extends UpdateProfileState {
  final MyProfileResponseModel myProfileResponseModel;
  UpdateProfileAboutMeDataSuccess(this.myProfileResponseModel);
}

// About Partner Data States
final class UpdateProfileAboutPartnerDataLoading extends UpdateProfileState {}

final class UpdateProfileAboutPartnerDataFailure extends UpdateProfileState {
  final String error;
  UpdateProfileAboutPartnerDataFailure(this.error);
}

final class UpdateProfileAboutPartnerDataSuccess extends UpdateProfileState {
  final MyProfileResponseModel myProfileResponseModel;
  UpdateProfileAboutPartnerDataSuccess(this.myProfileResponseModel);
}
