import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_cubit.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login_form.dart';
import '../../../../widgets/custom_auth_card.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({
    super.key,
    this.isFromLogout = false,
  });

  final bool isFromLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 34.w, right: 31.w, top: 32.13.h),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Show back arrow only when NOT coming from logout or splash
                      GestureDetector(
                        onTap: () {
                          context
                              .pushReplacementNamed(AppRoutes.onBoardingScreen);
                        },
                        child: Image.asset(
                          AppImages.authArrowBack,
                          width: 14.w,
                          height: 14.h,
                        ),
                      ),
                      verticalSpace(33.74.h),
                      verticalSpace(14),
                      Image.asset(
                        AppImages.authElsadekenMarriageImage,
                        width: 170.w,
                        height: 49.h,
                      ),
                      verticalSpace(30),
                      CustomAuthCard(
                        cardContent: BlocListener<LoginCubit, LoginState>(
                          listener: (context, state) {
                            if (state is LoginLoading) {
                              loadingDialog(context);
                            } else if (state is LoginFailure) {
                              context.pop();
                              errorDialog(
                                  context: context, error: state.errorMessage);
                            } else if (state is LoginBlocked) {
                              context.pop();
                              errorDialog(
                                  context: context, error: state.message);
                            } else if (state is LoginSuccess) {
                              context.pop();
                              // Show success dialog and navigate to home
                              // FCM token saving happens automatically in the background
                              successDialog(
                                  context: context,
                                  message: state.loginResponseModel.message,
                                  onPressed: () {
                                    context.pushNamedAndRemoveUntil(
                                        AppRoutes.homeScreen);
                                  });
                            }
                            // Note: FcmLoading, FcmSuccess, and FcmFailure states are not handled here
                            // because we don't want to show FCM-related dialogs to the user
                          },
                          child: LoginForm(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
