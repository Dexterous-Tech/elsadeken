import 'package:flutter/material.dart';

import '../../../../../../../core/theme/spacing.dart';
import '../custom_next_and_previous_button.dart';
import '../signup_multi_choice.dart';

class SignupBodyShape extends StatefulWidget {
  const SignupBodyShape({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupBodyShape> createState() => _SignupBodyShapeState();
}

class _SignupBodyShapeState extends State<SignupBodyShape> {
  String? _selectedSkin;

  final List<String> skinOptions = [
    'ابيض',
    'حنطي مائل للبياض',
    'حنطي مائل للسمار',
    'اسمر فاتح',
  ];

  String? _selectedBody;
  final List<String> bodyOptions = ['نحيف', 'قوام رياضي', 'متوسطه البنيه'];
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
                    title: 'ما هي لون بشرتك ؟',
                    options: skinOptions,
                    selected: _selectedSkin,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedSkin = newStatus;
                      });
                    },
                  ),

                  verticalSpace(40),

                  // multi wives
                  SignupMultiChoice(
                    title: 'ما هي بنيه الجسم ؟',
                    options: bodyOptions,
                    selected: _selectedBody,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedBody = newStatus;
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
