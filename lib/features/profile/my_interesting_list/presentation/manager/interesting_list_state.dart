import 'package:elsadeken/features/profile/interests_list/data/models/fav_user_list.dart';
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
  final FavUserListModel favUserListModel;
  InterestingListStateSuccess(this.favUserListModel);
}
