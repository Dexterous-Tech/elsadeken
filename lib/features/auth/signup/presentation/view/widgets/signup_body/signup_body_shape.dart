import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_choice_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/theme/spacing.dart';
import '../../../../data/models/general_info_models.dart';
import '../../../manager/sign_up_lists_cubit.dart';
import '../../../manager/signup_cubit.dart';
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
  GeneralInfoResponseModels? _selectedSkin;
  GeneralInfoResponseModels? _selectedBody;

  List<GeneralInfoResponseModels> _skinColors = [];
  List<GeneralInfoResponseModels> _physiques = [];

  // Track loading states separately
  bool _isLoadingSkinColors = true;
  bool _isLoadingPhysiques = true;

  @override
  void initState() {
    super.initState();
    // Load skin colors and physiques when widget initializes
    context.read<SignUpListsCubit>().getSkinColors();
    context.read<SignUpListsCubit>().getPhysiques();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpListsCubit, SignUpListsState>(
      listener: (context, state) {
        if (state is SkinColorsSuccess) {
          setState(() {
            _skinColors = state.generalList.cast<GeneralInfoResponseModels>();
            _isLoadingSkinColors = false;
          });
        } else if (state is PhysiquesSuccess) {
          setState(() {
            _physiques = state.generalList.cast<GeneralInfoResponseModels>();
            _isLoadingPhysiques = false;
          });
        } else if (state is SkinColorsLoading) {
          setState(() {
            _isLoadingSkinColors = true;
          });
        } else if (state is PhysiquesLoading) {
          setState(() {
            _isLoadingPhysiques = true;
          });
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Skin Color Selection
            if (_isLoadingSkinColors)
              SignupChoiceLoading(
                title: 'ما هي لون بشرتك ؟',
              )
            else
              SignupMultiChoice(
                title: 'ما هي لون بشرتك ؟',
                options: _skinColors.map((skin) => skin.name ?? '').toList(),
                selected: _selectedSkin?.name,
                onChanged: (newStatus) {
                  final selectedSkin = _skinColors.firstWhere(
                    (skin) => skin.name == newStatus,
                    orElse: () => GeneralInfoResponseModels(),
                  );
                  setState(() {
                    _selectedSkin = selectedSkin;
                  });
                  // Store the ID in the signup cubit
                  if (selectedSkin.id != null) {
                    context.read<SignupCubit>().skinColorController.text =
                        selectedSkin.id.toString();
                  }
                },
              ),

            verticalSpace(40),

            // Body Physique Selection
            if (_isLoadingPhysiques)
              SignupChoiceLoading(
                title: 'ما هي بنيه الجسم ؟',
              )
            else
              SignupMultiChoice(
                title: 'ما هي بنيه الجسم ؟',
                options:
                    _physiques.map((physique) => physique.name ?? '').toList(),
                selected: _selectedBody?.name,
                onChanged: (newStatus) {
                  final selectedPhysique = _physiques.firstWhere(
                    (physique) => physique.name == newStatus,
                    orElse: () => GeneralInfoResponseModels(),
                  );
                  setState(() {
                    _selectedBody = selectedPhysique;
                  });
                  // Store the ID in the signup cubit
                  if (selectedPhysique.id != null) {
                    context.read<SignupCubit>().physiqueController.text =
                        selectedPhysique.id.toString();
                  }
                },
              ),

            verticalSpace(50),

            Spacer(),

            CustomNextAndPreviousButton(
              onNextPressed: widget.onNextPressed,
              onPreviousPressed: widget.onPreviousPressed,
              isNextEnabled: _canProceedToNext(),
            ),
          ],
        );
      },
    );
  }

  bool _canProceedToNext() {
    // Check if both skin color and physique are selected
    bool hasSkinColor = _selectedSkin != null;
    bool hasPhysique = _selectedBody != null;

    return hasSkinColor && hasPhysique;
  }
}
