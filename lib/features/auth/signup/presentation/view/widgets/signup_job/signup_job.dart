import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_choice_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../../../../../../../core/services/localization_service.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/forms/custom_text_form_field.dart';
import '../../../../data/models/general_info_models.dart';
import '../custom_next_and_previous_button.dart';
import '../signup_multi_choice.dart';

class SignupJob extends StatefulWidget {
  const SignupJob(
      {super.key,
      required this.onNextPressed,
      required this.onPreviousPressed});

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupJob> createState() => _SignupJobState();
}

class _SignupJobState extends State<SignupJob> {
  GeneralInfoResponseModels? _selectedHealth;
  GeneralInfoResponseModels? _selectedIncomes;

  List<GeneralInfoResponseModels> _healthOptions = [];
  List<GeneralInfoResponseModels> _incomesOptions = [];

  // Track loading states separately
  bool _isLoadingHealthConditions = true;
  bool _isLoadingIncomes = true;

  @override
  void initState() {
    super.initState();
    // Load health conditions when widget initializes
    context.read<SignUpListsCubit>().getHealthConditions();
    context.read<SignUpListsCubit>().getIncomes();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<SignupCubit>();

    return BlocConsumer<SignUpListsCubit, SignUpListsState>(
      listener: (context, state) {
        if (state is HealthConditionsSuccess) {
          setState(() {
            _healthOptions =
                state.generalList.cast<GeneralInfoResponseModels>();
            _isLoadingHealthConditions = false;
          });
        } else if (state is IncomesSuccess) {
          setState(() {
            _incomesOptions =
                state.generalList.cast<GeneralInfoResponseModels>();
            _isLoadingIncomes = false;
          });
        } else if (state is HealthConditionsLoading) {
          setState(() {
            _isLoadingHealthConditions = true;
          });
        } else if (state is IncomesLoading) {
          setState(() {
            _isLoadingIncomes = true;
          });
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: LocalizationService.instance.textDirection,
                  children: [
                    Text(AppLocalizations.of(context)!.whatIsYourJob,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.jobController,
                      keyboardType: TextInputType.text,
                      hintText: AppLocalizations.of(context)!.jobHint,
                      inputFormatters: [
                        // Allow only Arabic & English letters and spaces (no numbers or links)
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\u0600-\u06FF\s]')),
                        LengthLimitingTextInputFormatter(
                            50), // Limit to 50 characters
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.jobRequired;
                        }
                        if (value.trim().length > 50) {
                          return AppLocalizations.of(context)!.jobTooLong;
                        }
                        // Extra safety: block if it looks like a link
                        if (RegExp(r'https?://|www\.|\.com').hasMatch(value)) {
                          return AppLocalizations.of(context)!.jobNoLinks;
                        }
                        return null;
                      },
                    ),
                    verticalSpace(40),

                    // Text(AppLocalizations.of(context)!.whatIsYourMonthlyIncome,
                    //     textDirection:
                    //         LocalizationService.instance.textDirection,
                    //     style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    // verticalSpace(16),
                    // // Income field
                    // CustomTextFormField(
                    //   controller: cubit.incomeController,
                    //   keyboardType: TextInputType.number,
                    //   hintText: '',
                    //   inputFormatters: [
                    //     FilteringTextInputFormatter.digitsOnly, // ✅ Only digits
                    //     LengthLimitingTextInputFormatter(
                    //         9), // Limit to reasonable length (e.g., no phone number length)
                    //   ],
                    //   validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return AppLocalizations.of(context)!.incomeRequired;
                    //     }
                    //
                    //     final income = int.tryParse(value);
                    //     if (income == null) {
                    //       return AppLocalizations.of(context)!
                    //           .pleaseEnterValidNumber;
                    //     }
                    //     if (income < 0) {
                    //       return AppLocalizations.of(context)!
                    //           .incomeCannotBeNegative;
                    //     }
                    //
                    //     return null;
                    //   },
                    // ),

                    // Income Selection
                    if (_isLoadingIncomes)
                      SignupChoiceLoading(
                        title: AppLocalizations.of(context)!
                            .whatIsYourMonthlyIncome,
                      )
                    else
                      SignupMultiChoice(
                        height: 170.h,
                        title: AppLocalizations.of(context)!
                            .whatIsYourMonthlyIncome,
                        options: _incomesOptions
                            .map((income) => income.name ?? '')
                            .toList(),
                        selected: _selectedIncomes?.name,
                        onChanged: (newStatus) {
                          final selectedIncome = _incomesOptions.firstWhere(
                            (income) => income.name == newStatus,
                            orElse: () => GeneralInfoResponseModels(),
                          );
                          setState(() {
                            _selectedIncomes = selectedIncome;
                          });
                          // Store the ID in the signup cubit
                          if (selectedIncome.id != null) {
                            context.read<SignupCubit>().incomeController.text =
                                selectedIncome.id.toString();
                          }
                        },
                      ),

                    verticalSpace(40),

                    // Health Condition Selection
                    if (_isLoadingHealthConditions)
                      SignupChoiceLoading(
                        title: AppLocalizations.of(context)!
                            .whatIsYourHealthStatus,
                      )
                    else
                      SignupMultiChoice(
                        height: 170.h,
                        title: AppLocalizations.of(context)!
                            .whatIsYourHealthStatus,
                        options: _healthOptions
                            .map((health) => health.name ?? '')
                            .toList(),
                        selected: _selectedHealth?.name,
                        onChanged: (newStatus) {
                          final selectedHealth = _healthOptions.firstWhere(
                            (health) => health.name == newStatus,
                            orElse: () => GeneralInfoResponseModels(),
                          );
                          setState(() {
                            _selectedHealth = selectedHealth;
                          });
                          // Store the ID in the signup cubit
                          if (selectedHealth.id != null) {
                            context
                                .read<SignupCubit>()
                                .healthConditionController
                                .text = selectedHealth.id.toString();
                          }
                        },
                      ),

                    Expanded(child: verticalSpace(50)),

                    CustomNextAndPreviousButton(
                      onNextPressed: widget.onNextPressed,
                      onPreviousPressed: widget.onPreviousPressed,
                      isNextEnabled: _canProceedToNext(cubit),
                    ),
                  ],
                )),
              ),
            );
          },
        );
      },
    );
  }

  bool _canProceedToNext(SignupCubit cubit) {
    // Must have job title
    bool hasJob = cubit.jobController.text.trim().isNotEmpty;

    // Must have income
    // bool hasIncome = cubit.incomeController.text.trim().isNotEmpty;
    bool hasIncome = _selectedIncomes != null;

    // Must select health condition
    bool hasHealthCondition = _selectedHealth != null;

    return hasJob && hasIncome && hasHealthCondition;
  }
}
