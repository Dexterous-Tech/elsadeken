import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_choice_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../../../../../../../core/services/localization_service.dart';
import '../../../../../../../core/theme/spacing.dart';
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
  GeneralInfoResponseModels? _selectedJobs;

  List<GeneralInfoResponseModels> _healthOptions = [];
  List<GeneralInfoResponseModels> _incomesOptions = [];
  List<GeneralInfoResponseModels> _jobsOptions = [];

  // Track loading states separately
  bool _isLoadingHealthConditions = true;
  bool _isLoadingIncomes = true;
  bool _isLoadingJobs = true;

  @override
  void initState() {
    super.initState();
    // Load health conditions when widget initializes
    context.read<SignUpListsCubit>().getHealthConditions();
    context.read<SignUpListsCubit>().getIncomes();
    context.read<SignUpListsCubit>().getJobs();
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
        }
        if (state is IncomesSuccess) {
          setState(() {
            _incomesOptions =
                state.generalList.cast<GeneralInfoResponseModels>();
            _isLoadingIncomes = false;
          });
        }
        if (state is JobsSuccess) {
          setState(() {
            _jobsOptions = state.generalList.cast<GeneralInfoResponseModels>();
            _isLoadingJobs = false;
          });
        }
        if (state is HealthConditionsLoading) {
          setState(() {
            _isLoadingHealthConditions = true;
          });
        }
        if (state is IncomesLoading) {
          setState(() {
            _isLoadingIncomes = true;
          });
        }
        if (state is JobsLoading) {
          setState(() {
            _isLoadingJobs = true;
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
                    //  job
                    if (_isLoadingJobs)
                      SignupChoiceLoading(
                        title: AppLocalizations.of(context)!.whatIsYourJob,
                      )
                    else
                      SignupMultiChoice(
                        height: 170.h,
                        title: AppLocalizations.of(context)!.whatIsYourJob,
                        options:
                            _jobsOptions.map((job) => job.name ?? '').toList(),
                        selected: _selectedJobs?.name,
                        onChanged: (newStatus) {
                          final selectedJob = _jobsOptions.firstWhere(
                            (job) => job.name == newStatus,
                            orElse: () => GeneralInfoResponseModels(),
                          );
                          setState(() {
                            _selectedJobs = selectedJob;
                          });
                          // Store the ID in the signup cubit
                          if (selectedJob.id != null) {
                            context.read<SignupCubit>().jobController.text =
                                selectedJob.id.toString();
                          }
                        },
                      ),
                    verticalSpace(20),

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

                    verticalSpace(20),

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
    bool hasJob = _selectedJobs != null;

    // Must have income
    // bool hasIncome = cubit.incomeController.text.trim().isNotEmpty;
    bool hasIncome = _selectedIncomes != null;

    // Must select health condition
    bool hasHealthCondition = _selectedHealth != null;

    return hasJob && hasIncome && hasHealthCondition;
  }
}
