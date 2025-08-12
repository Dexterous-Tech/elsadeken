part of 'signup_cubit.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {
  final SignupResponseModel signupResponseModel;

  SignupSuccess({required this.signupResponseModel});
}

final class SignupFailure extends SignupState {
  final String error;

  SignupFailure(this.error);
}

final class RegisterInformationLoading extends SignupState {}

final class RegisterInformationSuccess extends SignupState {
  final RegisterInformationResponseModel registerInformationResponseModel;

  RegisterInformationSuccess({required this.registerInformationResponseModel});
}

final class RegisterInformationFailure extends SignupState {
  final String error;

  RegisterInformationFailure(this.error);
}
