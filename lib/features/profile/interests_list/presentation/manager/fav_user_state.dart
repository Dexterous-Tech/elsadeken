import 'package:elsadeken/features/profile/interests_list/data/models/fav_user_list.dart';
import 'package:flutter/material.dart';

@immutable
sealed class FavUserState {}

final class FavUserInitial extends FavUserState {}

final class FavUserLoading extends FavUserState {}

final class FavUserFailure extends FavUserState {
  final String error;
  FavUserFailure(this.error);
}

final class FavUserSuccess extends FavUserState {
  final FavUserListModel favUserListModel;
  FavUserSuccess(this.favUserListModel);
}
