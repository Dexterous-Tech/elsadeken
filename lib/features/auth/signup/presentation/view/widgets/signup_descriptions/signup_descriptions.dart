import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/widgets/custom_radio.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/forms/custom_text_form_field.dart';
import '../custom_next_and_previous_button.dart';

class SignupDescriptions extends StatefulWidget {
  const SignupDescriptions({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupDescriptions> createState() => _SignupDescriptionsState();
}

class _SignupDescriptionsState extends State<SignupDescriptions> {
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (context, state) =>
          state is SignupLoading ||
          state is SignupFailure ||
          state is RegisterInformationLoading ||
          state is RegisterInformationFailure ||
          state is RegisterInformationSuccess,
      listener: (context, state) {
        if (state is SignupLoading || state is RegisterInformationLoading) {
          // Close any existing dialogs first, then show loading
          // Navigator.of(context).popUntil((route) => route.isFirst);
          loadingDialog(context);
        } else if (state is SignupFailure ||
            state is RegisterInformationFailure) {
          // Close loading dialog first, then show error with retry option
          context.pop();
          String errorMessage = '';
          if (state is SignupFailure) {
            errorMessage = state.error;
          } else if (state is RegisterInformationFailure) {
            errorMessage = state.error;
          }
          errorDialog(
            context: context,
            error: errorMessage,
            onPressed: () {
              // Close error dialog and retry
              Navigator.pop(context);
              // if (_canProceedToNext(cubit)) {
              //   // For register information errors, just retry the same method
              //   cubit.registerInformation();
              // }
            },
          );
        } else if (state is RegisterInformationSuccess) {
          // Close loading dialog first, then show success and navigate to login
          context.pop();
          successDialog(
              context: context,
              message: state.registerInformationResponseModel.message,
              onPressed: () async {
                Navigator.pop(context);
                // Clear the isSingle key from shared preferences
                await SharedPreferencesHelper.deleteSecuredString(
                    SharedPreferencesKey.isSingleKey);
                // Navigate to login (data is already cleared in cubit)
                if (context.mounted) {
                  context.pushReplacementNamed(AppRoutes.loginScreen);
                }
              });
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: LocalizationService.instance.textDirection,
                  children: [
                    // name
                    Text(AppLocalizations.of(context)!.aboutPartner,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),

                    CustomTextFormField(
                      controller: cubit.aboutMeController,
                      keyboardType: TextInputType.text,
                      hintText: AppLocalizations.of(context)!.writeHint,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }

                        final trimmedValue = value.trim();

                        // Block numbers
                        if (RegExp(r'\d').hasMatch(trimmedValue)) {
                          return AppLocalizations.of(context)!
                              .textCannotContainNumbers;
                        }

                        // Block anything that looks like a phone number (8–15 consecutive digits)
                        if (RegExp(r'\d{8,15}').hasMatch(trimmedValue)) {
                          return AppLocalizations.of(context)!
                              .cannotEnterPhoneNumber;
                        }

                        // Block links
                        if (RegExp(r'(https?://|www\.|\.com|\.net|\.org)',
                                caseSensitive: false)
                            .hasMatch(trimmedValue)) {
                          return AppLocalizations.of(context)!
                              .textCannotContainLinks;
                        }

                        return null;
                      },
                    ),

                    verticalSpace(40),

                    // email
                    Text(AppLocalizations.of(context)!.aboutMe,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.lifePartnerController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: AppLocalizations.of(context)!.writeHint,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }

                        final trimmedValue = value.trim();

                        // Block numbers
                        if (RegExp(r'\d').hasMatch(trimmedValue)) {
                          return AppLocalizations.of(context)!
                              .textCannotContainNumbers;
                        }

                        // Block anything that looks like a phone number (8–15 consecutive digits)
                        if (RegExp(r'\d{8,15}').hasMatch(trimmedValue)) {
                          return AppLocalizations.of(context)!
                              .cannotEnterPhoneNumber;
                        }

                        // Block links
                        if (RegExp(r'(https?://|www\.|\.com|\.net|\.org)',
                                caseSensitive: false)
                            .hasMatch(trimmedValue)) {
                          return AppLocalizations.of(context)!
                              .textCannotContainLinks;
                        }

                        return null;
                      },
                    ),

                    verticalSpace(50),

                    Row(
                      textDirection: LocalizationService.instance.textDirection,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomRadio(
                          value: agreedToTerms,
                          onChanged: () {
                            setState(() {
                              agreedToTerms = !agreedToTerms;
                            });
                          },
                        ),
                        horizontalSpace(10),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                  AppRoutes.termsAndConditionsScreen);
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .agreeToTermsAndConditions,
                              textDirection:
                                  LocalizationService.instance.textDirection,
                              textAlign:
                                  LocalizationService.instance.textAlignment,
                              style:
                                  AppTextStyles.font14PumpkinOrangeBoldLamaSans,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: verticalSpace(40)),
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return CustomNextAndPreviousButton(
                          textButton: AppLocalizations.of(context)!.login,
                          onNextPressed: () {
                            if (state is! SignupLoading &&
                                state is! RegisterInformationLoading &&
                                _canProceedToNext(cubit)) {
                              // Call registerInformation method
                              cubit.registerInformation();
                            }
                          },
                          onPreviousPressed: widget.onPreviousPressed,
                          isNextEnabled: state is! SignupLoading &&
                              state is! RegisterInformationLoading &&
                              _canProceedToNext(cubit),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _canProceedToNext(SignupCubit cubit) {
    // Check if all controllers have non-empty values
    bool hasAboutMe = cubit.aboutMeController.text.trim().isNotEmpty;
    bool hasPartner = cubit.lifePartnerController.text.trim().isNotEmpty;

    // Check if user agreed to terms and conditions
    bool agreedToTerms = this.agreedToTerms;

    // All conditions must be met to proceed
    return hasAboutMe && hasPartner && agreedToTerms;
  }
}
