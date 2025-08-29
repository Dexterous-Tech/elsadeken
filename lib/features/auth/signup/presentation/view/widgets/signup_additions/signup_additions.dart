import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/custom_next_and_previous_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/spacing.dart';

import '../signup_multi_choice.dart';

class SignupAdditions extends StatefulWidget {
  const SignupAdditions(
      {super.key,
      required this.onNextPressed,
      required this.onPreviousPressed,
      required this.gender});

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;
  final String gender;
  @override
  State<SignupAdditions> createState() => _SignupAdditionsState();
}

class _SignupAdditionsState extends State<SignupAdditions> {
  Map<String, String> get smokingOptions {
    return {
      '1': 'نعم',
      '0': 'لا',
    };
  }

  Map<String, String> get beardOptions {
    return {
      'beard': 'ملتحي',
      'without_beard': 'بدون لحية',
    };
  }

  Map<String, String> get hijabOptions {
    return {
      'not_hijab': 'غير محجبه',
      'hijab': 'محجبه(كشف الوجه)',
      'hijab_and_veil': 'محجبه (النقاب)',
      'hijab_face': 'محجبه (غطاء الوجه)',
      'dont_say': 'افضل الا اقول',
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
                    height: 110.h,
                    title: 'التدخين ؟',
                    options: smokingOptions.values.toList(),
                    selected: smokingOptions[cubit.smokingController.text],
                    onChanged: (newStatus) {
                      // Find the key for the selected Arabic text
                      String? selectedKey = smokingOptions.entries
                          .firstWhere((entry) => entry.value == newStatus,
                              orElse: () => const MapEntry('', ''))
                          .key;

                      if (selectedKey.isNotEmpty) {
                        cubit.smokingController.text = selectedKey;
                        setState(() {});
                      }
                    },
                  ),

                  verticalSpace(40),

                  // Beard selection for males
                  if (widget.gender == 'male' || widget.gender == 'ذكر')
                    SignupMultiChoice(
                        height: 110.h,
                        title: 'اللحية',
                        options: beardOptions.values.toList(),
                        selected: beardOptions[cubit.beardController.text],
                        onChanged: (newStatus) {
                          // Handle beard selection
                          String? selectedKey = beardOptions.entries
                              .firstWhere((entry) => entry.value == newStatus,
                                  orElse: () => const MapEntry('', ''))
                              .key;

                          if (selectedKey.isNotEmpty) {
                            cubit.beardController.text = selectedKey;
                            setState(() {});
                          }
                        }),

                  verticalSpace(40),

                  // Hijab selection for both males and females with different titles
                  SignupMultiChoice(
                      height: 170.h,
                      title: (widget.gender == 'male' || widget.gender == 'ذكر')
                          ? 'هل تريد شريك حياتك بحجاب ؟'
                          : 'الحجاب ؟',
                      options: hijabOptions.values.toList(),
                      selected: hijabOptions[cubit.hijabController.text],
                      onChanged: (newStatus) {
                        // Handle hijab selection
                        String? selectedKey = hijabOptions.entries
                            .firstWhere((entry) => entry.value == newStatus,
                                orElse: () => const MapEntry('', ''))
                            .key;

                        if (selectedKey.isNotEmpty) {
                          cubit.hijabController.text = selectedKey;
                          setState(() {});
                        }
                      }),

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
    // Must select smoking
    bool hasSmoking = cubit.smokingController.text.isNotEmpty &&
        smokingOptions.containsKey(cubit.smokingController.text);

    // Must select beard for males and hijab for both
    bool hasBeardOrHijab;
    if (widget.gender == 'male' || widget.gender == 'ذكر') {
      // For males: must have both beard and hijab
      bool hasBeard = cubit.beardController.text.isNotEmpty &&
          beardOptions.containsKey(cubit.beardController.text);
      bool hasHijab = cubit.hijabController.text.isNotEmpty &&
          hijabOptions.containsKey(cubit.hijabController.text);
      hasBeardOrHijab = hasBeard && hasHijab;
    } else {
      // For females: must have hijab
      hasBeardOrHijab = cubit.hijabController.text.isNotEmpty &&
          hijabOptions.containsKey(cubit.hijabController.text);
    }

    return hasSmoking && hasBeardOrHijab;
  }
}
