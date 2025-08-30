import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_page_view.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_steps_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupBody extends StatefulWidget {
  const SignupBody({
    super.key,
    required this.gender,
    this.initialStep = 0,
  });

  final String gender;
  final int initialStep;

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  late int _currentStep;
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

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
  }

  void _handleStepChanged(int newStep) {
    setState(() {
      _currentStep = newStep;
    });

    // Save the current step to shared preferences
    final cubit = SignupCubit.get(context);
    cubit.saveCurrentStep(newStep);

    // Save form data when step changes
    cubit.saveFormData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignUpListsCubit>(),
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
                  if (_currentStep != 2) ...[
                    horizontalSpace(8),
                    GestureDetector(
                      onTap: () {
                        if (_currentStep > 0) {
                          // Navigate to previous step
                          _handleStepChanged(_currentStep - 1);
                        } else {
                          // Pop context when on first step
                          context.pop();
                        }
                      },
                      child: Image.asset(
                        AppImages.authArrowBack,
                        width: 14.w,
                        height: 14.h,
                      ),
                    ),
                  ],
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
    );
  }
}
