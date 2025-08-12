part of 'verification_cubit.dart';

@immutable
sealed class VerificationState {}

final class VerificationInitial extends VerificationState {}
final class VerificationLoading extends VerificationState {}
final class VerificationFailure extends VerificationState {
  final String error ;

  VerificationFailure(this.error);
}
final class VerificationSuccess extends VerificationState {
  final VerificationResponseModel verificationResponseModel ;

  VerificationSuccess(this.verificationResponseModel);
}
