import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/services/localization_service.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../custom_next_and_previous_button.dart';
import '../signup_multi_choice.dart';

class SignupReligion extends StatefulWidget {
  const SignupReligion({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupReligion> createState() => _SignupReligionState();
}

class _SignupReligionState extends State<SignupReligion> {
  Map<String, String> religionOptions(BuildContext context) {
    return {
      'irreligious': AppLocalizations.of(context)!.irreligious,
      'little_religious': AppLocalizations.of(context)!.littleReligious,
      'religious': AppLocalizations.of(context)!.religious,
      'much_religious': AppLocalizations.of(context)!.muchReligious,
      'dont_say': AppLocalizations.of(context)!.dontSay,
    };
  }

  Map<String, String> prayerOptions(BuildContext context) {
    return {
      'always ': AppLocalizations.of(context)!.prayAlways,
      'most_times ': AppLocalizations.of(context)!.prayMostTimes,
      'sometimes ': AppLocalizations.of(context)!.praySometimes,
      'no_pray': AppLocalizations.of(context)!.noPray,
      'dont_say': AppLocalizations.of(context)!.dontSay,
    };
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
                  // status
                  SignupMultiChoice(
                    height: 170.h,
                    title: AppLocalizations.of(context)!
                        .whatIsYourReligiousCommitment,
                    options: religionOptions(context).values.toList(),
                    selected: religionOptions(
                        context)[cubit.religiousCommitmentController.text],
                    onChanged: (newStatus) {
                      // Find the key for the selected text
                      String? selectedKey = religionOptions(context)
                          .entries
                          .firstWhere((entry) => entry.value == newStatus,
                              orElse: () => const MapEntry('', ''))
                          .key;

                      if (selectedKey.isNotEmpty) {
                        cubit.religiousCommitmentController.text = selectedKey;
                        setState(() {});
                      }
                    },
                  ),

                  verticalSpace(40),

                  // multi wives
                  SignupMultiChoice(
                    height: 170.h,
                    title: AppLocalizations.of(context)!.prayer,
                    options: prayerOptions(context).values.toList(),
                    selected:
                        prayerOptions(context)[cubit.prayerController.text],
                    onChanged: (newStatus) {
                      // Find the key for the selected text
                      String? selectedKey = prayerOptions(context)
                          .entries
                          .firstWhere((entry) => entry.value == newStatus,
                              orElse: () => const MapEntry('', ''))
                          .key;

                      if (selectedKey.isNotEmpty) {
                        cubit.prayerController.text = selectedKey;
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
    // Must select religious commitment
    bool hasReligion = cubit.religiousCommitmentController.text.isNotEmpty &&
        religionOptions(context)
            .containsKey(cubit.religiousCommitmentController.text);

    // Must also select prayer status
    bool hasPrayer = cubit.prayerController.text.isNotEmpty &&
        prayerOptions(context).containsKey(cubit.prayerController.text);

    return hasReligion && hasPrayer;
  }
}
