part of 'reset_password_cubit.dart';

@immutable
sealed class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}
final class ResetPasswordLoading extends ResetPasswordState {}
final class ResetPasswordFailure extends ResetPasswordState {
  final String error ;

  ResetPasswordFailure(this.error);
}
final class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordResponseModel resetPasswordResponseModel;

  ResetPasswordSuccess(this.resetPasswordResponseModel);
}
