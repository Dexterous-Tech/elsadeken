import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/manager/verification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/custom_auth_body.dart';
import 'verification_email_form.dart';

class VerificationEmailBody extends StatelessWidget {
  const VerificationEmailBody({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return CustomAuthBody(
        cardContent: BlocListener<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is VerificationLoading) {
          loadingDialog(context);
        } else if (state is VerificationFailure) {
          context.pop();
          errorDialog(context: context, error: state.error);
        } else if (state is VerificationSuccess) {
          context.pop();
          successDialog(
              context: context,
              message: state.verificationResponseModel.message,
              onPressed: () {
                context.pushReplacementNamed(AppRoutes.newPasswordScreen , arguments: email);
              });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'رمز التحقق',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font27ChineseBlackBoldLamaSans(context),
          ),
          Text(
            'ادخل رقم رمز التحقق الذي تم ارساله الي البريد الالكتروني',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.font14BeerMediumLamaSans(
              context,
            ).copyWith(color: AppColors.outerSpace),
          ),
          verticalSpace(24),
          VerificationEmailForm(email: email),
        ],
      ),
    ));
  }
}
