import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/custom_next_and_previous_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Map<String, String> get scarfOptions {
    return {
      'hijab': 'محجبه',
      'hijab_and_veil': 'محجبه (النقاب)',
      'not_hijab ': 'غير محجبه',
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

                  // multi wives
                  SignupMultiChoice(
                      title: widget.gender == 'male'
                          ? 'هل تفضل أن ترتدي شريكتك الحجاب؟'
                          : 'الحجاب ؟',
                      options: scarfOptions.values.toList(),
                      selected: scarfOptions[cubit.hijabController.text],
                      onChanged: (newStatus) {
                        // Find the key for the selected Arabic text
                        String? selectedKey = scarfOptions.entries
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
    // Must select marital status
    bool hasScarf = cubit.hijabController.text.isNotEmpty &&
        scarfOptions.containsKey(cubit.hijabController.text);

    // Must also select type of marriage (required for both genders)
    bool hasSmoking = cubit.smokingController.text.isNotEmpty &&
        smokingOptions.containsKey(cubit.smokingController.text);

    return hasScarf && hasSmoking;
  }
}
