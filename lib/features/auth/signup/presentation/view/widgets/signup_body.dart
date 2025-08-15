import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_page_view.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_steps_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupBody extends StatefulWidget {
  const SignupBody({super.key, required this.gender});

  final String gender;

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  int _currentStep = 0;
  final List<String> pages = [
    'personal info',
    'passwords',
    'national',
    'country',
    'city',
    'social status',
    'general info',
    'body',
    'religion',
    'additions',
    'education',
    'job',
    'descriptions',
  ];

  void _handleStepChanged(int newStep) {
    setState(() {
      _currentStep = newStep;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignUpListsCubit>(),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is RegisterInformationLoading) {
            loadingDialog(context);
          } else if (state is RegisterInformationSuccess) {
            context.pop();
            successDialog(
                context: context,
                message: state.registerInformationResponseModel.message,
                onPressed: () {
                  context.pop();
                  context.pushReplacementNamed(AppRoutes.loginScreen);
                });
          } else if (state is RegisterInformationFailure) {
            context.pop();
            errorDialog(context: context, error: state.error);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SignupStepsProgress(
                        currentStep: _currentStep + 1,
                        totalSteps: pages.length,
                      ),
                    ),
                    horizontalSpace(8),
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Image.asset(
                        AppImages.arrowBack,
                        width: 14.w,
                        height: 14.h,
                      ),
                    ),
                  ],
                ),
                verticalSpace(33),
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    AppImages.authElsadekenMarriageImage,
                    width: 170.w,
                    height: 49.h,
                  ),
                ),
                verticalSpace(31),
                Expanded(
                  child: SignupPageView(
                    gender: widget.gender,
                    currentStep: _currentStep,
                    onStepChanged: _handleStepChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
