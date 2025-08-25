import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
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
  final UsersResponseModel favUserListModel;
  final bool hasNextPage;
  final int currentPage;

  FavUserSuccess(this.favUserListModel,
      {this.hasNextPage = false, this.currentPage = 1});
}
