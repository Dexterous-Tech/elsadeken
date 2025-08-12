import 'package:elsadeken/features/auth/forget_password/data/models/forget_models.dart';

class ForgetState {}

class ForgetInitial extends ForgetState {}

class ForgetLoading extends ForgetState {}

class ForgetSuccess extends ForgetState {
  final ForgetResponseModel forgetResponseModel;

  ForgetSuccess({required this.forgetResponseModel});
}

class ForgetFailure extends ForgetState {
  final String errorMessage;
  ForgetFailure(this.errorMessage);
}
