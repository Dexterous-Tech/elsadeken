import 'package:elsadeken/features/profile/profile_details/data/models/like_user_model.dart';
import 'package:flutter/material.dart';

@immutable
sealed class LikeUserState {}

final class LikeUserInitial extends LikeUserState {}

final class LikeUserLoading extends LikeUserState {}

final class LikeUserFailure extends LikeUserState {
  final String error;
  LikeUserFailure(this.error);
}

final class LikeUserSuccess extends LikeUserState {
  final LikeUserResponseModel responseModel;
  LikeUserSuccess(this.responseModel);
}
