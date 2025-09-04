import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../../../../../../../core/services/localization_service.dart';
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
              child: Form(
                key: cubit.generalInfoKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: LocalizationService.instance.textDirection,
                  children: [
                    Text(AppLocalizations.of(context)!.howOldAreYou,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.ageController,
                      keyboardType: TextInputType.number,
                      hintText: '',
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // ✅ Only numbers
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.ageRequired;
                        }
                        final age = int.tryParse(value);
                        if (age == null) {
                          return AppLocalizations.of(context)!
                              .pleaseEnterValidNumber;
                        }
                        if (age > 99 || age < 18) {
                          return AppLocalizations.of(context)!.ageRange;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {}); // Trigger rebuild for validation
                      },
                    ),
                    verticalSpace(40),
                    Text(AppLocalizations.of(context)!.howManyChildren,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.childrenNumberController,
                      keyboardType: TextInputType.number,
                      hintText: '',
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // ✅ Only numbers
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .numberOfChildrenRequired;
                        }
                        final children = int.tryParse(value);

                        if (children == null) {
                          return AppLocalizations.of(context)!
                              .pleaseEnterValidNumber;
                        }
                        if (children > 99 || children < 0) {
                          return AppLocalizations.of(context)!.childrenRange;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {}); // Trigger rebuild for validation
                      },
                    ),
                    verticalSpace(40),
                    Text(AppLocalizations.of(context)!.howMuchDoYouWeigh,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.weightController,
                      keyboardType: TextInputType.number,
                      hintText: '',
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // ✅ Only numbers
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.weightRequired;
                        }
                        final weight = int.tryParse(value);
                        if (weight == null) {
                          return AppLocalizations.of(context)!
                              .pleaseEnterValidNumber;
                        }
                        if (weight > 300 || weight < 30) {
                          return AppLocalizations.of(context)!.weightRange;
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {}); // Trigger rebuild for validation
                      },
                    ),
                    verticalSpace(40),
                    Text(AppLocalizations.of(context)!.howTallAreYou,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.heightController,
                      keyboardType: TextInputType.number,
                      hintText: '',
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // ✅ Only numbers
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.heightRequired;
                        }
                        final height = int.tryParse(value);
                        if (height == null) {
                          return AppLocalizations.of(context)!
                              .pleaseEnterValidNumber;
                        }
                        if (height > 250 || height < 50) {
                          return AppLocalizations.of(context)!.heightRange;
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
                      onNextPressed: () {
                        final formState = cubit.generalInfoKey.currentState;
                        if (formState != null && formState.validate()) {
                          widget.onNextPressed();
                        }
                      },
                      onPreviousPressed: widget.onPreviousPressed,
                      isNextEnabled: _canProceedToNext(cubit),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _canProceedToNext(SignupCubit cubit) {
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
