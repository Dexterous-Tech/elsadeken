import 'package:flutter/material.dart';

import '../../../../../../../core/theme/spacing.dart';
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
  String? _selectedEducation;

  final List<String> educationOptions = [
    'دراسه اعداديه',
    'دراسه ثانويها',
    'دراسه جامعيه',
    'دكتوراه',
  ];

  String? _selectedFinancial;
  final List<String> financialOptions = ['قليل', 'متوسط', 'اكثر من متوسط'];
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
                    title: 'ما هو المؤهل التعليمي ؟',
                    options: educationOptions,
                    selected: _selectedEducation,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedEducation = newStatus;
                      });
                    },
                  ),

                  verticalSpace(40),

                  // multi wives
                  SignupMultiChoice(
                    title: 'الوضع المادي ؟',
                    options: financialOptions,
                    selected: _selectedFinancial,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedFinancial = newStatus;
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
