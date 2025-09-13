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

    // Debug: Print gender value to understand what we're receiving
    print('DEBUG: Gender value: "${profileData?.gender}"');
    print('DEBUG: Is male: ${_isMale(profileData?.gender)}');
    print(
        'DEBUG: Current marital status: "${profileData?.attribute?.maritalStatus}"');
    print(
        'DEBUG: Current type of marriage: "${profileData?.attribute?.typeOfMarriage}"');

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
          options: _isMale(profileData?.gender)
              ? [
                  AppLocalizations.of(context)!.single,
                  AppLocalizations.of(context)!.married,
                  AppLocalizations.of(context)!.divorced,
                  AppLocalizations.of(context)!.widowed,
                ]
              : [
                  AppLocalizations.of(context)!.singleFemale,
                  AppLocalizations.of(context)!.marriedFemale,
                  AppLocalizations.of(context)!.divorcedFemale,
                  AppLocalizations.of(context)!.widowedFemale,
                ],
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.marriageType,
          hint: AppLocalizations.of(context)!.chooseMarriageType,
          currentValue: _mapTypeOfMarriageToDisplay(
              profileData?.attribute?.typeOfMarriage, context),
          type: ManageProfileFieldType.dropdown,
          options: _isMale(profileData?.gender)
              ? [
                  AppLocalizations.of(context)!.firstWife,
                  AppLocalizations.of(context)!.secondWife,
                ]
              : [
                  AppLocalizations.of(context)!.onlyHusband,
                  AppLocalizations.of(context)!.noObjectionToPolygamy,
                ],
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.age,
          hint: AppLocalizations.of(context)!.enterAge,
          currentValue: profileData?.attribute?.age?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.numberOfChildren,
          hint: AppLocalizations.of(context)!.enterNumberOfChildren,
          currentValue: profileData?.attribute?.children?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
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

  /// Helper method to map API marital status values to display values
  String _mapMaritalStatusToDisplay(String? apiValue, BuildContext context) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();

    // Map API values to display values
    switch (value.toLowerCase()) {
      case 'single':
        return _isMale(profileData?.gender)
            ? AppLocalizations.of(context)!.single
            : AppLocalizations.of(context)!.singleFemale;
      case 'married':
        return _isMale(profileData?.gender)
            ? AppLocalizations.of(context)!.married
            : '';
      case 'divorced':
        return _isMale(profileData?.gender)
            ? AppLocalizations.of(context)!.divorced
            : AppLocalizations.of(context)!.divorcedFemale;
      case 'widower':
        return _isMale(profileData?.gender)
            ? AppLocalizations.of(context)!.widowed
            : AppLocalizations.of(context)!.widowedFemale;
      default:
        // If it's already in Arabic, return as is
        return value;
    }
  }

  /// Helper method to map API type of marriage values to display values
  String _mapTypeOfMarriageToDisplay(String? apiValue, BuildContext context) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();

    // Map API values to display values
    switch (value.toLowerCase()) {
      case 'only_one':
        return _isMale(profileData?.gender)
            ? AppLocalizations.of(context)!.firstWife
            : AppLocalizations.of(context)!.onlyHusband;
      case 'multi':
        return _isMale(profileData?.gender)
            ? AppLocalizations.of(context)!.secondWife
            : AppLocalizations.of(context)!.noObjectionToPolygamy;
      default:
        // If it's already in Arabic, return as is
        return value;
    }
  }
}
