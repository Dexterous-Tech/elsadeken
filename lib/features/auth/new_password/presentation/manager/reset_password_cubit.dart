import 'package:elsadeken/features/auth/new_password/data/models/reset_password_models.dart';
import 'package:elsadeken/features/auth/new_password/data/repo/reset_password_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this.resetPasswordRepoInterface) : super(ResetPasswordInitial());

  final ResetPasswordRepoInterface resetPasswordRepoInterface;

  static ResetPasswordCubit get(BuildContext context) =>
      BlocProvider.of(context);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmPasswordController = TextEditingController();

  void login({required String email  , required String token}) async {
    emit(ResetPasswordLoading());
    var response = await resetPasswordRepoInterface.resetPassword(
      ResetPasswordRequestBodyModel(
        newPassword: newPasswordController.text,
        email: email,
        newConfirmPassword : newConfirmPasswordController.text ,
        token : token ,
      ),
    );

    response.fold(
          (error) {
        emit(ResetPasswordFailure(error.displayMessage));
      },
          (resetPasswordResponseModel) {
        emit(ResetPasswordSuccess(resetPasswordResponseModel));
      },
    );
  }
}
