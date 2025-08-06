import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/forms/custom_text_form_field.dart';
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
  String? _selectedSalary;

  final List<String> salaryOptions = ['اقل من 500 جنيه', 'اكثر من 500 جنيه'];

  String? _selectedHealth;
  final List<String> healthOptions = ['الحاله جيده', 'اعاقه حركيه'];
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
                  Text(
                    'ما هي وظيفتك ؟',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font23ChineseBlackBoldLamaSans(
                      context,
                    ),
                  ),
                  verticalSpace(16),
                  CustomTextFormField(
                    keyboardType: TextInputType.text,
                    hintText: 'وظيفة',
                    validator: (value) {},
                  ),
                  verticalSpace(40),

                  // status
                  SignupMultiChoice(
                    title: 'ما هو الدخل الشهري ؟',
                    options: salaryOptions,
                    selected: _selectedSalary,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedSalary = newStatus;
                      });
                    },
                  ),

                  verticalSpace(40),

                  // multi wives
                  SignupMultiChoice(
                    title: 'ما هي الحاله الصحيه؟',
                    options: healthOptions,
                    selected: _selectedHealth,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedHealth = newStatus;
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
