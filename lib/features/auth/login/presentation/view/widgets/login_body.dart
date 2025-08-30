import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_cubit.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form.dart';
import '../../../../widgets/custom_auth_body.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAuthBody(
        cardContent: BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          loadingDialog(context);
        } else if (state is LoginFailure) {
          context.pop();
          errorDialog(context: context, error: state.errorMessage);
        } else if (state is LoginBlocked) {
          context.pop();
          errorDialog(context: context, error: state.message);
        } else if (state is LoginSuccess) {
          context.pop();
          // Show success dialog and navigate to home
          // FCM token saving happens automatically in the background
          successDialog(
              context: context,
              message: state.loginResponseModel.message,
              onPressed: () {
                context.pushNamedAndRemoveUntil(AppRoutes.homeScreen);
              });
        }
        // Note: FcmLoading, FcmSuccess, and FcmFailure states are not handled here
        // because we don't want to show FCM-related dialogs to the user
      },
      child: LoginForm(),
    ));
  }
}
