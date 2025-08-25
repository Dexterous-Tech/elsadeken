import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:flutter/material.dart';

@immutable
sealed class InterestingListState {}

final class InterestingListStateInitial extends InterestingListState {}

final class InterestingListStateLoading extends InterestingListState {}

final class InterestingListStateFailure extends InterestingListState {
  final String error;
  InterestingListStateFailure(this.error);
}

final class InterestingListStateSuccess extends InterestingListState {
  final UsersResponseModel favUserListModel;
  final bool hasNextPage;
  final int currentPage;

  InterestingListStateSuccess(this.favUserListModel,
      {this.hasNextPage = false, this.currentPage = 1});
}
