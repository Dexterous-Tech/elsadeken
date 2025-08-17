import 'package:equatable/equatable.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';

abstract class IgnoreUserState extends Equatable {
  const IgnoreUserState();

  @override
  List<Object> get props => [];
}

class IgnoreUserInitial extends IgnoreUserState {}

class IgnoreUserLoading extends IgnoreUserState {}

class IgnoreUserSuccess extends IgnoreUserState {
  final UsersResponseModel ignoreUsersResponseModel;

  const IgnoreUserSuccess(this.ignoreUsersResponseModel);

  @override
  List<Object> get props => [ignoreUsersResponseModel];
}

class IgnoreUserFailure extends IgnoreUserState {
  final String errorMessage;

  const IgnoreUserFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
