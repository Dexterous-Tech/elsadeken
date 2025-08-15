import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/theme/spacing.dart';
import '../../../manager/signup_cubit.dart';
import '../custom_next_and_previous_button.dart';
import '../signup_multi_choice.dart';

class SignupSocialStatus extends StatefulWidget {
  const SignupSocialStatus({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
    required this.gender,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;
  final String gender;

  @override
  State<SignupSocialStatus> createState() => _SignupSocialStatusState();
}

class _SignupSocialStatusState extends State<SignupSocialStatus> {
  // Marital status options - different for male and female
  Map<String, String> get maritalStatusOptions {
    if (widget.gender.toLowerCase() == 'male') {
      return {
        'single': 'أعزب',
        'married': 'متزوج',
        'divorced': 'مطلق',
        'widwed': 'أرمل',
      };
    } else {
      return {
        'single': 'عزباء',
        'married': 'متزوجة',
        'divorced': 'مطلقة',
        'widwed': 'أرملة',
      };
    }
  }

  // Type of marriage options
  final Map<String, String> typeOfMarriageOptions = {
    'only_one': 'الزوجة الوحيدة',
    'multi': 'لا مانع من تعدد الزوجات',
  };

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
                  // Marital Status
                  SignupMultiChoice(
                    title: 'ما هي الحالة الاجتماعية ؟',
                    options: maritalStatusOptions.values.toList(),
                    selected: maritalStatusOptions[
                        cubit.maritalStatusController.text],
                    onChanged: (newStatus) {
                      // Find the key for the selected Arabic text
                      String? selectedKey = maritalStatusOptions.entries
                          .firstWhere((entry) => entry.value == newStatus,
                              orElse: () => const MapEntry('', ''))
                          .key;

                      if (selectedKey.isNotEmpty) {
                        cubit.maritalStatusController.text = selectedKey;
                        setState(() {});
                      }
                    },
                  ),

                  verticalSpace(40),

                  // Type of Marriage - show for both genders
                  SignupMultiChoice(
                    title: 'ما هو نوع الزواج ؟',
                    options: typeOfMarriageOptions.values.toList(),
                    selected: typeOfMarriageOptions[
                        cubit.typeOfMarriageController.text],
                    onChanged: (newType) {
                      // Find the key for the selected Arabic text
                      String? selectedKey = typeOfMarriageOptions.entries
                          .firstWhere((entry) => entry.value == newType,
                              orElse: () => const MapEntry('', ''))
                          .key;

                      if (selectedKey.isNotEmpty) {
                        cubit.typeOfMarriageController.text = selectedKey;
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
    bool hasMaritalStatus = cubit.maritalStatusController.text.isNotEmpty &&
        maritalStatusOptions.containsKey(cubit.maritalStatusController.text);

    // Must also select type of marriage (required for both genders)
    bool hasTypeOfMarriage = cubit.typeOfMarriageController.text.isNotEmpty &&
        typeOfMarriageOptions.containsKey(cubit.typeOfMarriageController.text);

    return hasMaritalStatus && hasTypeOfMarriage;
  }
}
