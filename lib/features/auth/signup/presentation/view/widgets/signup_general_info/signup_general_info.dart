import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../../../../../../../core/services/localization_service.dart';
import '../../../../../../../core/theme/spacing.dart';
import '../../../../../../../core/widgets/forms/custom_carousel_text_field.dart';
import '../../../../../../../core/shared/shared_preferences_helper.dart';
import '../../../manager/signup_cubit.dart';
import '../custom_next_and_previous_button.dart';

class SignupGeneralInfo extends StatefulWidget {
  const SignupGeneralInfo({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupGeneralInfo> createState() => _SignupGeneralInfoState();
}

class _SignupGeneralInfoState extends State<SignupGeneralInfo> {
  bool _isSingle = false;

  @override
  void initState() {
    super.initState();
    _loadIsSingleStatus();
  }

  Future<void> _loadIsSingleStatus() async {
    final isSingle = await SharedPreferencesHelper.getIsSingle();
    if (mounted) {
      setState(() {
        _isSingle = isSingle;
      });

      // If user is single, set children number to "0" (this will be handled in cubit)
      if (_isSingle) {
        final cubit = context.read<SignupCubit>();
        cubit.childrenNumberController.text = "0";
      }
    }
  }

  // Helper methods to generate lists for dropdowns
  List<String> get _ageList {
    List<String> ages = [];
    for (int i = 18; i <= 99; i++) {
      ages.add(i.toString());
    }
    return ages;
  }

  List<String> get _childrenList {
    List<String> children = [];
    // Start from 0 to 20 (include 0 option)
    for (int i = 0; i <= 20; i++) {
      children.add(i.toString());
    }
    return children;
  }

  List<String> get _weightList {
    List<String> weights = [];
    for (int i = 30; i <= 200; i++) {
      weights.add(i.toString());
    }
    return weights;
  }

  List<String> get _heightList {
    List<String> heights = [];
    for (int i = 50; i <= 220; i++) {
      heights.add(i.toString());
    }
    return heights;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: LocalizationService.instance.textDirection,
                children: [
                  CustomCarouselTextField(
                    label: AppLocalizations.of(context)!.howOldAreYou,
                    items: _ageList,
                    hintText: AppLocalizations.of(context)!.age,
                    initialValue: cubit.ageController.text.isNotEmpty
                        ? cubit.ageController.text
                        : null,
                    onChanged: (value) {
                      cubit.ageController.text = value;
                      setState(() {}); // Trigger rebuild for validation
                    },
                  ),
                  verticalSpace(40),
                  // Only show children field if user is not single
                  if (!_isSingle) ...[
                    CustomCarouselTextField(
                      label: AppLocalizations.of(context)!.howManyChildren,
                      items: _childrenList,
                      hintText: AppLocalizations.of(context)!.children,
                      initialValue:
                          cubit.childrenNumberController.text.isNotEmpty
                              ? cubit.childrenNumberController.text
                              : null,
                      onChanged: (value) {
                        cubit.childrenNumberController.text = value;
                        setState(() {}); // Trigger rebuild for validation
                      },
                    ),
                    verticalSpace(40),
                  ],
                  CustomCarouselTextField(
                    label: AppLocalizations.of(context)!.howMuchDoYouWeigh,
                    items: _weightList,
                    hintText: AppLocalizations.of(context)!.weight,
                    initialValue: cubit.weightController.text.isNotEmpty
                        ? cubit.weightController.text
                        : null,
                    onChanged: (value) {
                      cubit.weightController.text = value;
                      setState(() {}); // Trigger rebuild for validation
                    },
                  ),
                  verticalSpace(40),
                  CustomCarouselTextField(
                    label: AppLocalizations.of(context)!.howTallAreYou,
                    items: _heightList,
                    hintText: AppLocalizations.of(context)!.height,
                    initialValue: cubit.heightController.text.isNotEmpty
                        ? cubit.heightController.text
                        : null,
                    onChanged: (value) {
                      cubit.heightController.text = value;
                      setState(() {}); // Trigger rebuild for validation
                    },
                  ),
                  verticalSpace(50),
                  Spacer(),
                  CustomNextAndPreviousButton(
                    onNextPressed: () {
                      if (_canProceedToNext(cubit)) {
                        widget.onNextPressed();
                      }
                    },
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
    // Since we're using dropdowns with predefined values, we just need to check if values are not empty
    bool hasAge = cubit.ageController.text.trim().isNotEmpty;
    bool hasChildrenNumber = _isSingle
        ? true
        : cubit.childrenNumberController.text.trim().isNotEmpty;
    bool hasWeight = cubit.weightController.text.trim().isNotEmpty;
    bool hasHeight = cubit.heightController.text.trim().isNotEmpty;

    return hasAge && hasChildrenNumber && hasWeight && hasHeight;
  }
}
