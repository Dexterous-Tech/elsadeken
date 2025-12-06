import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';

class ManageProfileReligion extends StatelessWidget {
  const ManageProfileReligion({
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
          title: AppLocalizations.of(context)!.religiousCommitment,
          itemContent: ManageProfileContentText(
            text: _mapReligionToDisplay(
                context, profileData?.attribute?.religiousCommitment),
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.prayerTitle,
          itemContent: ManageProfileContentText(
            text: _mapPrayerToDisplay(context, profileData?.attribute?.prayer),
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.smoking,
          itemContent: ManageProfileContentText(
            text: _getSmokingDisplayValue(
                context, profileData?.attribute?.smoking),
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        // Show beard for males only
        if (profileData?.gender!.toLowerCase() == 'male' ||
            profileData?.gender == 'ذكر')
          ManageProfileContentItem(
            title: AppLocalizations.of(context)!.beardTitle,
            itemContent: ManageProfileContentText(
              text: _mapBeardToDisplay(context, profileData?.attribute?.beard),
              isLoading: isLoading,
            ),
          ),
        // Show hijab for females only
        if (profileData?.gender!.toLowerCase() != 'male' &&
            profileData?.gender != 'ذكر')
          ManageProfileContentItem(
            title: AppLocalizations.of(context)!.hijabTitle,
            itemContent: ManageProfileContentText(
              text: _mapHijabToDisplay(context, profileData?.attribute?.hijab),
              isLoading: isLoading,
            ),
          ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: isLoading ? null : () => _showReligionEditDialog(context),
        )
      ],
    );
  }

  void _showReligionEditDialog(BuildContext context) {
    final updateProfileCubit = context.read<UpdateProfileCubit>();

    final religionOptions = _getReligionOptions(context);
    final prayerOptions = _getPrayerOptions(context);
    final smokingOptions = _getSmokingOptions(context);
    final beardOptions = _getBeardOptions(context);
    final hijabOptions = _getHijabOptions(context);

    final dialogData = ManageProfileDialogData(
      title: AppLocalizations.of(context)!.editReligiousInfo,
      cubit: updateProfileCubit,
      signUpListsCubit: null, // No lists needed for religious data
      dialogType: ManageProfileDialogType.religion,
      fields: [
        ManageProfileField(
          label: AppLocalizations.of(context)!.religiousCommitment,
          hint: AppLocalizations.of(context)!.chooseReligiousCommitmentLevel,
          currentValue: _mapReligionToDisplay(
              context, profileData?.attribute?.religiousCommitment),
          type: ManageProfileFieldType.dropdown,
          keyValueOptions: religionOptions,
          isRequired: false, // Make optional
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.prayer,
          hint: AppLocalizations.of(context)!.choosePrayerStatus,
          currentValue:
              _mapPrayerToDisplay(context, profileData?.attribute?.prayer),
          type: ManageProfileFieldType.dropdown,
          keyValueOptions: prayerOptions,
          isRequired: false, // Make optional
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.smoking,
          hint: AppLocalizations.of(context)!.chooseSmokingStatus,
          currentValue:
              _getSmokingDisplayValue(context, profileData?.attribute?.smoking),
          type: ManageProfileFieldType.dropdown,
          keyValueOptions: smokingOptions,
          isRequired: false, // Make optional
        ),
        // Show beard for males only
        if (profileData?.gender?.toLowerCase() == 'male' ||
            profileData?.gender == 'ذكر')
          ManageProfileField(
            label: AppLocalizations.of(context)!.beardTitle,
            hint: AppLocalizations.of(context)!.chooseBeardStatus,
            currentValue:
                _mapBeardToDisplay(context, profileData?.attribute?.beard),
            type: ManageProfileFieldType.dropdown,
            keyValueOptions: beardOptions,
            isRequired: false, // Make optional
          ),
        // Show hijab for females only
        if (profileData?.gender?.toLowerCase() != 'male' &&
            profileData?.gender != 'ذكر')
          ManageProfileField(
            label: AppLocalizations.of(context)!.hijabTitle,
            hint: AppLocalizations.of(context)!.chooseHijabStatus,
            currentValue:
                _mapHijabToDisplay(context, profileData?.attribute?.hijab),
            type: ManageProfileFieldType.dropdown,
            keyValueOptions: hijabOptions,
            isRequired: false, // Make optional
          ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }

  /// Get smoking options - same as signup
  Map<String, String> _getSmokingOptions(BuildContext context) {
    return {
      '1': AppLocalizations.of(context)!.yesIam,
      '0': AppLocalizations.of(context)!.noIam,
    };
  }

  /// Get beard options - same as signup
  Map<String, String> _getBeardOptions(BuildContext context) {
    return {
      'beard': AppLocalizations.of(context)!.beard,
      'without_beard': AppLocalizations.of(context)!.withoutBeard,
    };
  }

  /// Get hijab options - same as signup
  Map<String, String> _getHijabOptions(BuildContext context) {
    return {
      'not_hijab': AppLocalizations.of(context)!.notHijab,
      'hijab': AppLocalizations.of(context)!.hijabFaceVisible,
      'hijab_and_veil': AppLocalizations.of(context)!.hijabAndVeil,
      'hijab_face': AppLocalizations.of(context)!.hijab_face,
      'dont_say': AppLocalizations.of(context)!.dontSay,
    };
  }

  /// Get religion options based on gender - same as signup
  Map<String, String> _getReligionOptions(BuildContext context) {
    if (profileData?.gender?.toLowerCase() == 'male' ||
        profileData?.gender == 'ذكر') {
      return {
        'irreligious': AppLocalizations.of(context)!.irreligious,
        'little_religious': AppLocalizations.of(context)!.littleReligious,
        'religious': AppLocalizations.of(context)!.religious,
        'much_religious': AppLocalizations.of(context)!.muchReligious,
        'dont_say': AppLocalizations.of(context)!.dontSay,
      };
    } else {
      return {
        'irreligious': AppLocalizations.of(context)!.irreligiousFemale,
        'little_religious': AppLocalizations.of(context)!.littleReligiousFemale,
        'religious': AppLocalizations.of(context)!.religiousFemale,
        'much_religious': AppLocalizations.of(context)!.muchReligiousFemale,
        'dont_say': AppLocalizations.of(context)!.dontSay,
      };
    }
  }

  /// Get prayer options - same as signup
  Map<String, String> _getPrayerOptions(BuildContext context) {
    return {
      'always': AppLocalizations.of(context)!.prayAlways,
      'most_times': AppLocalizations.of(context)!.prayMostTimes,
      'sometimes': AppLocalizations.of(context)!.praySometimes,
      'no_pray': AppLocalizations.of(context)!.noPray,
      'dont_say': AppLocalizations.of(context)!.dontSay,
    };
  }

  /// Helper method to convert smoking API value to localized display text
  String _getSmokingDisplayValue(BuildContext context, String? smoking) {
    if (smoking == null || smoking.isEmpty) return '';

    final value = smoking.toString().trim();
    final options = _getSmokingOptions(context);

    // If the value is already a key in our options, return the display value
    if (options.containsKey(value)) {
      return options[value]!;
    }

    // Handle legacy values
    String smokingValue = value.toLowerCase();
    if (smokingValue == '1' ||
        smokingValue == 'true' ||
        smokingValue == 'yes' ||
        smokingValue == 'smoking') {
      return AppLocalizations.of(context)!.yesIam;
    }
    if (smokingValue == '0' ||
        smokingValue == 'false' ||
        smokingValue == 'no' ||
        smokingValue == 'not smoking') {
      return AppLocalizations.of(context)!.noIam;
    }

    // If it's already a display value, return as is
    if (options.containsValue(value)) {
      return value;
    }

    // Default case - return the original value if we can't map it
    return smoking;
  }

  /// Helper method to map API religion values to display values
  String _mapReligionToDisplay(BuildContext context, String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();
    final options = _getReligionOptions(context);

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

  /// Helper method to map API prayer values to display values
  String _mapPrayerToDisplay(BuildContext context, String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();
    final options = _getPrayerOptions(context);

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

  /// Helper method to map API beard values to display values
  String _mapBeardToDisplay(BuildContext context, String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();
    final options = _getBeardOptions(context);

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

  /// Helper method to map API hijab values to display values
  String _mapHijabToDisplay(BuildContext context, String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();
    final options = _getHijabOptions(context);

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
