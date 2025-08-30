import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

import '../../data/models/login_models.dart';

class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseModel loginResponseModel;

  LoginSuccess({required this.loginResponseModel});
}

class LoginBlocked extends LoginState {
  final String message;

  LoginBlocked({required this.message});
}

class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

class FcmLoading extends LoginState {}

class FcmFailure extends LoginState {
  final String error;

  FcmFailure(this.error);
}

class FcmSuccess extends LoginState {
  final ProfileActionResponseModel profileActionResponseModel;

  FcmSuccess(this.profileActionResponseModel);
}
