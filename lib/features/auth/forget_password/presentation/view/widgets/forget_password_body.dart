import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_cubit.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_state.dart';
import 'package:elsadeken/features/auth/widgets/custom_auth_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forget_password_form.dart';

class ForgetPasswordBody extends StatelessWidget {
  const ForgetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAuthBody(
        cardContent: BlocListener<ForgetCubit, ForgetState>(
      listener: (context, state) {
        if (state is ForgetLoading) {
          loadingDialog(context);
        } else if (state is ForgetFailure) {
          context.pop();
          errorDialog(context: context, error: state.errorMessage);
        } else if (state is ForgetSuccess) {
          var cubit = ForgetCubit.get(context);
          context.pop();
          successDialog(
              context: context,
              message: state.forgetResponseModel.message,
              onPressed: () {
                context.pushReplacementNamed(AppRoutes.verificationEmailScreen,
                    arguments: cubit.emailController.text);
              });
        }
      },
      child: ForgetPasswordForm(),
    ));
  }
}
