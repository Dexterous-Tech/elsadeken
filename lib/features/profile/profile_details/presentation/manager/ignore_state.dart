import 'package:elsadeken/features/profile/profile_details/data/models/like_user_model.dart';
import 'package:flutter/material.dart';

@immutable
sealed class IgnoreUserState {}

final class IgnoreUserInitial extends IgnoreUserState {}

final class IgnoreUserLoading extends IgnoreUserState {}

final class IgnoreUserFailure extends IgnoreUserState {
  final String error;
  IgnoreUserFailure(this.error);
}

final class IgnoreUserSuccess extends IgnoreUserState {
  final LikeUserResponseModel responseModel;
  IgnoreUserSuccess(this.responseModel);
}
