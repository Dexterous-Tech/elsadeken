import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../../../../../../../core/services/localization_service.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../manager/signup_cubit.dart';
import '../custom_next_and_previous_button.dart';
import '../signup_multi_choice.dart';

class SignupSocialStatus extends StatefulWidget {
  const SignupSocialStatus({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
    required this.gender,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;
  final String gender;

  @override
  State<SignupSocialStatus> createState() => _SignupSocialStatusState();
}

class _SignupSocialStatusState extends State<SignupSocialStatus> {
  // Marital status options - different for male and female
  Map<String, String> maritalStatusOptions(BuildContext context) {
    if (widget.gender.toLowerCase() == 'male') {
      return {
        'single': AppLocalizations.of(context)!.singleMale,
        'married': AppLocalizations.of(context)!.married,
        'divorced': AppLocalizations.of(context)!.divorcedMale,
        'widower': AppLocalizations.of(context)!.widower,
      };
    } else {
      return {
        'single': AppLocalizations.of(context)!.singleFemale,
        'divorced': AppLocalizations.of(context)!.divorcedFemale,
        'widower': AppLocalizations.of(context)!.widow,
      };
    }
  }

  // Type of marriage options
  Map<String, String> typeOfMarriageOptions(BuildContext context) {
    if (widget.gender.toLowerCase() == 'male') {
      return {
        'only_one': AppLocalizations.of(context)!.firstWife,
        'multi': AppLocalizations.of(context)!.secondWife,
      };
    } else {
      return {
        'only_one': AppLocalizations.of(context)!.onlyWife,
        'multi': AppLocalizations.of(context)!.noObjectionToPolygamy,
      };
    }
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: LocalizationService.instance.textDirection,
                children: [
                  // Marital Status
                  SignupMultiChoice(
                    height: 225.h,
                    title: AppLocalizations.of(context)!.whatIsMaritalStatus,
                    options: maritalStatusOptions(context).values.toList(),
                    selected: maritalStatusOptions(context)[
                        cubit.maritalStatusController.text],
                    onChanged: (newStatus) {
                      // Find the key for the selected text
                      String? selectedKey = maritalStatusOptions(context).entries
                          .firstWhere((entry) => entry.value == newStatus,
                              orElse: () => const MapEntry('', ''))
                          .key;

                      if (selectedKey.isNotEmpty) {
                        cubit.maritalStatusController.text = selectedKey;
                        setState(() {});
                      }
                    },
                  ),

                  verticalSpace(40),

                  // Type of Marriage - show for both genders
                  SignupMultiChoice(
                    height: 110.h,
                    title: AppLocalizations.of(context)!.whatIsMarriageType,
                    options: typeOfMarriageOptions(context).values.toList(),
                    selected: typeOfMarriageOptions(context)[
                        cubit.typeOfMarriageController.text],
                    onChanged: (newType) {
                      // Find the key for the selected text
                      String? selectedKey = typeOfMarriageOptions(context).entries
                          .firstWhere((entry) => entry.value == newType,
                              orElse: () => const MapEntry('', ''))
                          .key;

                      if (selectedKey.isNotEmpty) {
                        cubit.typeOfMarriageController.text = selectedKey;
                        setState(() {});
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
              ),
            ),
          ),
        );
      },
    );
  }

  bool _canProceedToNext(SignupCubit cubit) {
    // Must select marital status
    bool hasMaritalStatus = cubit.maritalStatusController.text.isNotEmpty &&
        maritalStatusOptions(context).containsKey(cubit.maritalStatusController.text);

    // Must also select type of marriage (required for both genders)
    bool hasTypeOfMarriage = cubit.typeOfMarriageController.text.isNotEmpty &&
        typeOfMarriageOptions(context).containsKey(cubit.typeOfMarriageController.text);

    return hasMaritalStatus && hasTypeOfMarriage;
  }
}
