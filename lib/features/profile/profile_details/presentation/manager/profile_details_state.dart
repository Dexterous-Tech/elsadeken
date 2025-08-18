part of 'profile_details_cubit.dart';

@immutable
sealed class ProfileDetailsState {}

final class ProfileDetailsInitial extends ProfileDetailsState {}
final class LikeUserLoading extends ProfileDetailsState {}
final class LikeUserFailure extends ProfileDetailsState {
  final String error ;

  LikeUserFailure(this.error);
}
final class LikeUserSuccess extends ProfileDetailsState {
  final ProfileDetailsActionResponseModel profileDetailsActionResponseModel;

  LikeUserSuccess(this.profileDetailsActionResponseModel);
}


final class IgnoreUserLoading extends ProfileDetailsState {}
final class IgnoreUserFailure extends ProfileDetailsState {
  final String error ;

  IgnoreUserFailure(this.error);
}
final class IgnoreUserSuccess extends ProfileDetailsState {
  final ProfileDetailsActionResponseModel profileDetailsActionResponseModel;

  IgnoreUserSuccess(this.profileDetailsActionResponseModel);
}

final class GetProfileDetailsLoading extends ProfileDetailsState {}
final class GetProfileDetailsFailure extends ProfileDetailsState {
  final String error;

  GetProfileDetailsFailure(this.error);
}
final class GetProfileDetailsSuccess extends ProfileDetailsState {
  final ProfileDetailsResponseModel profileDetailsResponseModel;

  GetProfileDetailsSuccess(this.profileDetailsResponseModel);
}