part of 'members_profile_cubit.dart';

abstract class MembersProfileState {}

class MembersProfileStateInitial extends MembersProfileState {}

class MembersProfileStateLoading extends MembersProfileState {}

class MembersProfileStateSuccess extends MembersProfileState {
  final MembersProfileResponseModel membersProfileResponseModel;
  final bool hasNextPage;
  final int currentPage;

  MembersProfileStateSuccess(
    this.membersProfileResponseModel, {
    required this.hasNextPage,
    required this.currentPage,
  });
}

class MembersProfileStateFailure extends MembersProfileState {
  final String error;

  MembersProfileStateFailure(this.error);
}
