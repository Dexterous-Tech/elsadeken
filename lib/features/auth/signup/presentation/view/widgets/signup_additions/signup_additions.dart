import 'package:elsadeken/features/auth/signup/presentation/view/widgets/custom_next_and_previous_button.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/theme/spacing.dart';

import '../signup_multi_choice.dart';

class SignupAdditions extends StatefulWidget {
  const SignupAdditions(
      {super.key,
      required this.onNextPressed,
      required this.onPreviousPressed});

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;
  @override
  State<SignupAdditions> createState() => _SignupAdditionsState();
}

class _SignupAdditionsState extends State<SignupAdditions> {
  String? _selectedSmoking;

  final List<String> smokingOptions = ['نعم', 'لا'];

  String? _selectedScarf;
  final List<String> scarfOptions = ['غير محجبه', 'محجبه (النقاب)', 'محجبه'];
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
                    title: 'التدخين ؟',
                    options: smokingOptions,
                    selected: _selectedSmoking,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedSmoking = newStatus;
                      });
                    },
                  ),

                  verticalSpace(40),

                  // multi wives
                  SignupMultiChoice(
                    title: 'الحجاب ؟',
                    options: scarfOptions,
                    selected: _selectedScarf,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedScarf = newStatus;
                      });
                    },
                  ),

                  verticalSpace(50),
                  Spacer(),

                  CustomNextAndPreviousButton(
                      onNextPressed: widget.onNextPressed,
                      onPreviousPressed: widget.onPreviousPressed),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
