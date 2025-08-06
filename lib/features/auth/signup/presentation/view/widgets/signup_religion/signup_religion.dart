import 'package:flutter/material.dart';

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
  String? _selectedReligion;

  final List<String> religionOptions = [
    'غير متدين',
    'متدين قليلا',
    'متدين',
  ];

  String? _selectedPrayer;
  final List<String> prayerOptions = [
    'اصلي دائما',
    'اصلي اغلب الاوقات',
    'لا اصلي',
  ];
  @override
  Widget build(BuildContext context) {
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
                    title: 'ما هي التزامك الديني ؟',
                    options: religionOptions,
                    selected: _selectedReligion,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedReligion = newStatus;
                      });
                    },
                  ),

                  verticalSpace(40),

                  // multi wives
                  SignupMultiChoice(
                    title: 'الصلاه ؟',
                    options: prayerOptions,
                    selected: _selectedPrayer,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedPrayer = newStatus;
                      });
                    },
                  ),

                  verticalSpace(50),

                  Spacer(),

                  CustomNextAndPreviousButton(
                    onNextPressed: widget.onNextPressed,
                    onPreviousPressed: widget.onPreviousPressed,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
