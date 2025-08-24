import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  Map<String, String> get religionOptions {
    return {
      'religious': 'غير متدين',
      'little_religious': 'متدين قليلا',
      'irreligious': 'متدين',
    };
  }

  Map<String, String> get prayerOptions {
    return {
      'always ': 'اصلي دائما',
      'interittent ': 'اصلي اغلب الاوقات',
      'no_pray': 'لا اصلي',
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // status
                  SignupMultiChoice(
                    height: 170.h,
                    title: 'ما هي التزامك الديني ؟',
                    options: religionOptions.values.toList(),
                    selected: religionOptions[
                        cubit.religiousCommitmentController.text],
                    onChanged: (newStatus) {
                      // Find the key for the selected Arabic text
                      String? selectedKey = religionOptions.entries
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
                    title: 'الصلاه ؟',
                    options: prayerOptions.values.toList(),
                    selected: prayerOptions[cubit.prayerController.text],
                    onChanged: (newStatus) {
                      // Find the key for the selected Arabic text
                      String? selectedKey = prayerOptions.entries
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
    // Must select marital status
    bool hasReligion = cubit.religiousCommitmentController.text.isNotEmpty &&
        religionOptions.containsKey(cubit.religiousCommitmentController.text);

    // Must also select type of marriage (required for both genders)
    bool hasPrayer = cubit.prayerController.text.isNotEmpty &&
        prayerOptions.containsKey(cubit.prayerController.text);

    return hasReligion && hasPrayer;
  }
}
