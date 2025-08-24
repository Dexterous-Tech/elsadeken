import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_choice_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  List<GeneralInfoResponseModels> _healthOptions = [];

  @override
  void initState() {
    super.initState();
    // Load health conditions when widget initializes
    context.read<SignUpListsCubit>().getHealthConditions();
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
          });
        }
      },
      builder: (context, state) {
        // Check if data is loading
        bool isLoadingHealth = state is HealthConditionsLoading;

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('ما هي وظيفتك ؟',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    CustomTextFormField(
                      controller: cubit.jobController,
                      keyboardType: TextInputType.text,
                      hintText: 'وظيفة',
                      inputFormatters: [
                        // Allow only Arabic & English letters and spaces (no numbers or links)
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\u0600-\u06FF\s]')),
                        LengthLimitingTextInputFormatter(
                            50), // Limit to 50 characters
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يجب إدخال الوظيفة';
                        }
                        if (value.trim().length > 50) {
                          return 'الوظيفة يجب ألا تتجاوز 50 حرفًا';
                        }
                        // Extra safety: block if it looks like a link
                        if (RegExp(r'https?://|www\.|\.com').hasMatch(value)) {
                          return 'الوظيفة لا يمكن أن تحتوي على روابط';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(40),

                    Text('ما هو الدخل الشهري ؟',
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.font23ChineseBlackBoldLamaSans),
                    verticalSpace(16),
                    // Income field
                    CustomTextFormField(
                      controller: cubit.incomeController,
                      keyboardType: TextInputType.number,
                      hintText: '5000',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // ✅ Only digits
                        LengthLimitingTextInputFormatter(
                            9), // Limit to reasonable length (e.g., no phone number length)
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يجب إدخال الدخل';
                        }

                        final income = int.tryParse(value);
                        if (income == null) {
                          return 'يرجى إدخال رقم صحيح';
                        }

                        return null;
                      },
                    ),

                    verticalSpace(40),

                    // Health Condition Selection
                    if (isLoadingHealth)
                      SignupChoiceLoading(
                        title: 'ما هي الحاله الصحيه؟',
                      )
                    else
                      SignupMultiChoice(
                        height: 100.h,
                        title: 'ما هي الحاله الصحيه؟',
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

                    verticalSpace(50),
                    Spacer(),

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
    bool hasIncome = cubit.incomeController.text.trim().isNotEmpty;

    // Must select health condition
    bool hasHealthCondition = _selectedHealth != null;

    return hasJob && hasIncome && hasHealthCondition;
  }
}
