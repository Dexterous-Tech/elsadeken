import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/forms/custom_text_form_field.dart';
import '../../../manager/signup_cubit.dart';
import '../custom_next_and_previous_button.dart';

class SignupGeneralInfo extends StatefulWidget {
  const SignupGeneralInfo({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupGeneralInfo> createState() => _SignupGeneralInfoState();
}

class _SignupGeneralInfoState extends State<SignupGeneralInfo> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'كم عمرك ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    controller: cubit.ageController,
                    keyboardType: TextInputType.number,
                    hintText: '25',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'العمر مطلوب';
                      }
                      if (int.tryParse(value) == null) {
                        return 'يرجى إدخال رقم صحيح';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild for validation
                    },
                  ),
                  verticalSpace(40),
                  Text(
                    'كم عدد الاطفال ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    controller: cubit.childrenNumberController,
                    keyboardType: TextInputType.number,
                    hintText: '0',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'عدد الأطفال مطلوب';
                      }
                      if (int.tryParse(value) == null) {
                        return 'يرجى إدخال رقم صحيح';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild for validation
                    },
                  ),
                  verticalSpace(40),
                  Text(
                    'كم وزنك (كجم) ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    controller: cubit.weightController,
                    keyboardType: TextInputType.number,
                    hintText: '70',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الوزن مطلوب';
                      }
                      if (int.tryParse(value) == null) {
                        return 'يرجى إدخال رقم صحيح';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild for validation
                    },
                  ),
                  verticalSpace(40),
                  Text(
                    'كم طولك (سم) ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    controller: cubit.heightController,
                    keyboardType: TextInputType.number,
                    hintText: '180',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الطول مطلوب';
                      }
                      if (int.tryParse(value) == null) {
                        return 'يرجى إدخال رقم صحيح';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild for validation
                    },
                  ),
                  verticalSpace(50),
                  Spacer(),
                  CustomNextAndPreviousButton(
                    onNextPressed: widget.onNextPressed,
                    onPreviousPressed: widget.onPreviousPressed,
                    isNextEnabled: _canProceedToNext(cubit),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _canProceedToNext(SignupCubit cubit) {
    // Check if all controllers have non-empty values
    bool hasAge = cubit.ageController.text.trim().isNotEmpty &&
        int.tryParse(cubit.ageController.text) != null;
    bool hasChildrenNumber =
        cubit.childrenNumberController.text.trim().isNotEmpty &&
            int.tryParse(cubit.childrenNumberController.text) != null;
    bool hasWeight = cubit.weightController.text.trim().isNotEmpty &&
        int.tryParse(cubit.weightController.text) != null;
    bool hasHeight = cubit.heightController.text.trim().isNotEmpty &&
        int.tryParse(cubit.heightController.text) != null;

    return hasAge && hasChildrenNumber && hasWeight && hasHeight;
  }
}
