import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';

class ManageProfileMaritalStatus extends StatelessWidget {
  const ManageProfileMaritalStatus({
    super.key,
    this.profileData,
    this.isLoading = false,
  });

  final MyProfileDataModel? profileData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: LocalizationService.instance.textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.maritalStatus,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.maritalStatus ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.marriageType,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.typeOfMarriage ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.age,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.age?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.children,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.children?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed:
              isLoading ? null : () => _showMaritalStatusEditDialog(context),
        )
      ],
    );
  }

  void _showMaritalStatusEditDialog(BuildContext context) {
    final updateProfileCubit = context.read<UpdateProfileCubit>();

    final maritalStatusOptions = _getMaritalStatusOptions(context);
    final typeOfMarriageOptions = _getTypeOfMarriageOptions(context);

    final dialogData = ManageProfileDialogData(
      title: AppLocalizations.of(context)!.editMaritalStatus,
      cubit: updateProfileCubit,
      signUpListsCubit: null, // Marital status doesn't need SignUpListsCubit
      dialogType: ManageProfileDialogType.socialStatus,
      fields: [
        ManageProfileField(
          label: AppLocalizations.of(context)!.maritalStatus,
          hint: AppLocalizations.of(context)!.chooseMaritalStatus,
          currentValue: _mapMaritalStatusToDisplay(
              profileData?.attribute?.maritalStatus, context),
          type: ManageProfileFieldType.dropdown,
          keyValueOptions: maritalStatusOptions,
          isRequired: false, // Make optional
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.marriageType,
          hint: AppLocalizations.of(context)!.chooseMarriageType,
          currentValue: _mapTypeOfMarriageToDisplay(
              profileData?.attribute?.typeOfMarriage, context),
          type: ManageProfileFieldType.dropdown,
          keyValueOptions: typeOfMarriageOptions,
          isRequired: false, // Make optional
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.age,
          hint: AppLocalizations.of(context)!.enterAge,
          currentValue: profileData?.attribute?.age?.toString() ?? '',
          type: ManageProfileFieldType.dropdown,
          keyValueOptions: _getAgeOptions(),
          isRequired: false, // Make optional
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.numberOfChildren,
          hint: AppLocalizations.of(context)!.enterNumberOfChildren,
          currentValue: profileData?.attribute?.children?.toString() ?? '',
          type: ManageProfileFieldType.dropdown,
          keyValueOptions: _getChildrenOptions(),
          isRequired: false, // Make optional
        ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }

  /// Helper method to determine if the user is male
  /// Handles both Arabic and English gender values
  bool _isMale(String? gender) {
    if (gender == null || gender.isEmpty) return false;

    final genderLower = gender.toLowerCase().trim();

    // Check for Arabic gender values
    if (genderLower == 'ذكر' || genderLower == 'male') {
      return true;
    }

    // Check for English gender values
    if (genderLower == 'male' || genderLower == 'm') {
      return true;
    }

    return false;
  }

  /// Get marital status options based on gender - same as signup
  Map<String, String> _getMaritalStatusOptions(BuildContext context) {
    if (_isMale(profileData?.gender)) {
      return {
        'single': AppLocalizations.of(context)!.singleMale,
        'married': AppLocalizations.of(context)!.married,
        'divorced': AppLocalizations.of(context)!.divorcedMale,
        'widower': AppLocalizations.of(context)!.widower,
      };
    } else {
      return {
        'single': AppLocalizations.of(context)!.singleFemale,
        'divorced': AppLocalizations.of(context)!.divorcedFemale,
        'widower': AppLocalizations.of(context)!.widow,
      };
    }
  }

  /// Get type of marriage options based on gender - same as signup
  Map<String, String> _getTypeOfMarriageOptions(BuildContext context) {
    if (_isMale(profileData?.gender)) {
      return {
        'only_one': AppLocalizations.of(context)!.firstWife,
        'multi': AppLocalizations.of(context)!.secondWife,
      };
    } else {
      return {
        'only_one': AppLocalizations.of(context)!.onlyHusband,
        'multi': AppLocalizations.of(context)!.noObjectionToPolygamy,
      };
    }
  }

  /// Get age options (18-99)
  Map<String, String> _getAgeOptions() {
    Map<String, String> ageOptions = {};
    for (int i = 18; i <= 99; i++) {
      ageOptions[i.toString()] = i.toString();
    }
    return ageOptions;
  }

  /// Get children options (0-20)
  Map<String, String> _getChildrenOptions() {
    Map<String, String> childrenOptions = {};
    for (int i = 0; i <= 20; i++) {
      childrenOptions[i.toString()] = i.toString();
    }
    return childrenOptions;
  }

  /// Helper method to map API marital status values to display values
  String _mapMaritalStatusToDisplay(String? apiValue, BuildContext context) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();
    final options = _getMaritalStatusOptions(context);

    // If the value is already a key in our options, return the display value
    if (options.containsKey(value)) {
      return options[value]!;
    }

    // If it's already a display value, return as is
    if (options.containsValue(value)) {
      return value;
    }

    // Default case - return the original value
    return value;
  }

  /// Helper method to map API type of marriage values to display values
  String _mapTypeOfMarriageToDisplay(String? apiValue, BuildContext context) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();
    final options = _getTypeOfMarriageOptions(context);

    // If the value is already a key in our options, return the display value
    if (options.containsKey(value)) {
      return options[value]!;
    }

    // If it's already a display value, return as is
    if (options.containsValue(value)) {
      return value;
    }

    // Default case - return the original value
    return value;
  }
}
