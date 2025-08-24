import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_choice_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/theme/spacing.dart';
import '../../../../data/models/general_info_models.dart';
import '../../../manager/sign_up_lists_cubit.dart';
import '../../../manager/signup_cubit.dart';
import '../custom_next_and_previous_button.dart';
import '../signup_multi_choice.dart';

class SignupEducation extends StatefulWidget {
  const SignupEducation({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupEducation> createState() => _SignupEducationState();
}

class _SignupEducationState extends State<SignupEducation> {
  GeneralInfoResponseModels? _selectedEducation;
  GeneralInfoResponseModels? _selectedFinancial;

  List<GeneralInfoResponseModels> _educationOptions = [];
  List<GeneralInfoResponseModels> _financialOptions = [];

  // Track loading states separately
  bool _isLoadingEducation = true;
  bool _isLoadingFinancial = true;

  @override
  void initState() {
    super.initState();
    // Load qualifications and financial situations when widget initializes
    context.read<SignUpListsCubit>().getQualification();
    context.read<SignUpListsCubit>().getFinancialSituations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpListsCubit, SignUpListsState>(
      listener: (context, state) {
        if (state is QualificationsSuccess) {
          setState(() {
            _educationOptions =
                state.generalList.cast<GeneralInfoResponseModels>();
            _isLoadingEducation = false;
          });
        } else if (state is FinancialSituationsSuccess) {
          setState(() {
            _financialOptions =
                state.generalList.cast<GeneralInfoResponseModels>();
            _isLoadingFinancial = false;
          });
        } else if (state is QualificationsLoading) {
          setState(() {
            _isLoadingEducation = true;
          });
        } else if (state is FinancialSituationsLoading) {
          setState(() {
            _isLoadingFinancial = true;
          });
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Educational Qualification Selection
              if (_isLoadingEducation)
                SignupChoiceLoading(
                  title: 'ما هو المؤهل التعليمي ؟',
                )
              else
                SignupMultiChoice(
                  height: 120.h,
                  title: 'ما هو المؤهل التعليمي ؟',
                  options:
                      _educationOptions.map((edu) => edu.name ?? '').toList(),
                  selected: _selectedEducation?.name,
                  onChanged: (newStatus) {
                    final selectedEducation = _educationOptions.firstWhere(
                      (edu) => edu.name == newStatus,
                      orElse: () => GeneralInfoResponseModels(),
                    );
                    setState(() {
                      _selectedEducation = selectedEducation;
                    });
                    // Store the ID in the signup cubit
                    if (selectedEducation.id != null) {
                      context
                          .read<SignupCubit>()
                          .educationalQualificationController
                          .text = selectedEducation.id.toString();
                    }
                  },
                ),

              verticalSpace(40),

              // Financial Situation Selection
              if (_isLoadingFinancial)
                SignupChoiceLoading(
                  title: 'الوضع المادي ؟',
                )
              else
                SignupMultiChoice(
                  height: 120.h,
                  title: 'الوضع المادي ؟',
                  options: _financialOptions
                      .map((financial) => financial.name ?? '')
                      .toList(),
                  selected: _selectedFinancial?.name,
                  onChanged: (newStatus) {
                    final selectedFinancial = _financialOptions.firstWhere(
                      (financial) => financial.name == newStatus,
                      orElse: () => GeneralInfoResponseModels(),
                    );
                    setState(() {
                      _selectedFinancial = selectedFinancial;
                    });
                    // Store the ID in the signup cubit
                    if (selectedFinancial.id != null) {
                      context
                          .read<SignupCubit>()
                          .financialSituationController
                          .text = selectedFinancial.id.toString();
                    }
                  },
                ),

              verticalSpace(50),
              SizedBox(height: 100), // Add space for the buttons at the bottom

              CustomNextAndPreviousButton(
                onNextPressed: widget.onNextPressed,
                onPreviousPressed: widget.onPreviousPressed,
                isNextEnabled: _canProceedToNext(),
              ),
              verticalSpace(20), // Add bottom padding for scroll safety
            ],
          ),
        );
      },
    );
  }

  bool _canProceedToNext() {
    // Check if both education and financial situation are selected
    bool hasEducation = _selectedEducation != null;
    bool hasFinancial = _selectedFinancial != null;

    return hasEducation && hasFinancial;
  }
}
