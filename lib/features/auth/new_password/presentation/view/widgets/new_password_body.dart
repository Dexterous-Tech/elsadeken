import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/auth/new_password/presentation/manager/reset_password_cubit.dart';
import 'package:elsadeken/features/auth/new_password/presentation/view/widgets/new_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/custom_auth_body.dart';

class NewPasswordBody extends StatelessWidget {
  const NewPasswordBody({super.key, required this.email});

  final String email;
  @override
  Widget build(BuildContext context) {
    return CustomAuthBody(
        cardContent: BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordLoading) {
          loadingDialog(context);
        } else if (state is ResetPasswordFailure) {
          context.pop();
          errorDialog(context: context, error: state.error);
        } else if (state is ResetPasswordSuccess) {
          context.pop();
          successDialog(
              context: context,
              message: state.resetPasswordResponseModel.message,
              onPressed: () {
                context.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
              });
        }
      },
      child: NewPasswordForm(
        email: email,
      ),
    ));
  }
}
