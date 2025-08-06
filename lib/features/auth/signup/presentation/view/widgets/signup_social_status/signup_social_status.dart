import 'package:flutter/material.dart';

import '../../../../../../../core/theme/spacing.dart';
import '../custom_next_and_previous_button.dart';
import '../signup_multi_choice.dart';

class SignupSocialStatus extends StatefulWidget {
  const SignupSocialStatus({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupSocialStatus> createState() => _SignupSocialStatusState();
}

class _SignupSocialStatusState extends State<SignupSocialStatus> {
  String? _selectedStatus;

  final List<String> statusOptions = ['اعزب', 'مطلق', 'متزوج'];

  String? _selectedCount;
  final List<String> wivesCount = ['الزوجه الوحيده', 'لا مانع من تعدد الزوجات'];
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
                    title: 'ما هي الحاله الاجتماعيه ؟',
                    options: statusOptions,
                    selected: _selectedStatus,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedStatus = newStatus;
                      });
                    },
                  ),

                  verticalSpace(40),

                  // multi wives
                  SignupMultiChoice(
                    title: 'ما هي نوع الزواج ؟',
                    options: wivesCount,
                    selected: _selectedCount,
                    onChanged: (newStatus) {
                      // Handle the new selection
                      setState(() {
                        _selectedCount = newStatus;
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
