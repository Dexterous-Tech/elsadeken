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
            text: _mapReligionToDisplay(context, profileData?.attribute?.religiousCommitment),
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.prayer,
          itemContent: ManageProfileContentText(
            text: _mapPrayerToDisplay(context, profileData?.attribute?.prayer),
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.smoking,
          itemContent: ManageProfileContentText(
            text: _getSmokingDisplayValue(context, profileData?.attribute?.smoking),
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        // Show beard for males only
        if (profileData?.gender == 'male' || profileData?.gender == 'ذكر')
          ManageProfileContentItem(
            title: AppLocalizations.of(context)!.beard,
            itemContent: ManageProfileContentText(
              text: _mapBeardToDisplay(context, profileData?.attribute?.beard),
              isLoading: isLoading,
            ),
          ),
        // Show hijab for females only
        if (profileData?.gender != 'male' && profileData?.gender != 'ذكر')
          ManageProfileContentItem(
            title: AppLocalizations.of(context)!.hijab,
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

    // Debug: Print current values to understand what we're receiving
    print(
        'DEBUG: Religious Commitment: "${profileData?.attribute?.religiousCommitment}"');
    print('DEBUG: Prayer: "${profileData?.attribute?.prayer}"');
    print('DEBUG: Smoking: "${profileData?.attribute?.smoking}"');
    print('DEBUG: Hijab: "${profileData?.attribute?.hijab}"');

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
          options: _getReligionOptions(context),
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.prayer,
          hint: AppLocalizations.of(context)!.choosePrayerStatus,
          currentValue: _mapPrayerToDisplay(context, profileData?.attribute?.prayer),
          type: ManageProfileFieldType.dropdown,
          options: _getPrayerOptions(context),
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.smoking,
          hint: AppLocalizations.of(context)!.chooseSmokingStatus,
          currentValue: _getSmokingDisplayValue(context, profileData?.attribute?.smoking),
          type: ManageProfileFieldType.dropdown,
          options: [
            AppLocalizations.of(context)!.yes,
            AppLocalizations.of(context)!.no,
          ],
        ),
        // Show beard for males only
        if (profileData?.gender == 'male' || profileData?.gender == 'ذكر')
          ManageProfileField(
            label: AppLocalizations.of(context)!.beard,
            hint: AppLocalizations.of(context)!.chooseBeardStatus,
            currentValue: _mapBeardToDisplay(context, profileData?.attribute?.beard),
            type: ManageProfileFieldType.dropdown,
            options: _getBeardOptions(context),
          ),
        // Show hijab for females only
        if (profileData?.gender != 'male' && profileData?.gender != 'ذكر')
          ManageProfileField(
            label: AppLocalizations.of(context)!.hijab,
            hint: AppLocalizations.of(context)!.chooseHijabStatus,
            currentValue: _mapHijabToDisplay(context, profileData?.attribute?.hijab),
            type: ManageProfileFieldType.dropdown,
            options: _getHijabOptions(context),
          ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }

  /// Helper method to convert smoking API value to localized display text
  String _getSmokingDisplayValue(BuildContext context, String? smoking) {
    if (smoking == null || smoking.isEmpty) return '';

    // Handle both string and numeric values
    String smokingValue = smoking.toString().toLowerCase().trim();
    
    if (smokingValue == '1' || smokingValue == 'نعم' || smokingValue == 'true' || smokingValue == 'yes' || smokingValue == 'smoking') {
      return AppLocalizations.of(context)!.yes;
    }
    if (smokingValue == '0' || smokingValue == 'لا' || smokingValue == 'false' || smokingValue == 'no' || smokingValue == 'not smoking') {
      return AppLocalizations.of(context)!.no;
    }

    // If it's already a display value, return as is
    if (smokingValue == 'نعم') {
      return AppLocalizations.of(context)!.yes;
    }
    if (smokingValue == 'لا') {
      return AppLocalizations.of(context)!.no;
    }

    // Default case - return the original value if we can't map it
    return smoking;
  }

  /// Get localized religion options
  List<String> _getReligionOptions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.irreligious,
      AppLocalizations.of(context)!.littleReligious,
      AppLocalizations.of(context)!.religious,
      AppLocalizations.of(context)!.muchReligious,
      AppLocalizations.of(context)!.dontSay,
    ];
  }

  /// Get localized prayer options
  List<String> _getPrayerOptions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.prayAlways,
      AppLocalizations.of(context)!.prayMostTimes,
      AppLocalizations.of(context)!.praySometimes,
      AppLocalizations.of(context)!.noPray,
      AppLocalizations.of(context)!.dontSay,
    ];
  }

  /// Get localized beard options
  List<String> _getBeardOptions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.withBeard,
      AppLocalizations.of(context)!.withoutBeard,
    ];
  }

  /// Get localized hijab options
  List<String> _getHijabOptions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.notHijab,
      AppLocalizations.of(context)!.hijabFaceVisible,
      AppLocalizations.of(context)!.hijabWithVeil,
      AppLocalizations.of(context)!.hijabFaceCovered,
      AppLocalizations.of(context)!.dontSay,
    ];
  }

  /// Helper method to map API religion values to display values
  String _mapReligionToDisplay(BuildContext context, String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    // If it's already a display value, return as is
    if (['غير متدين', 'متدين قليلاً', 'متدين', 'متدين كثيراً', 'أفضل ألا أقول'].contains(apiValue)) {
      return apiValue;
    }

    // Map API values to display values
    switch (apiValue.toLowerCase().trim()) {
      case 'irreligious':
      case 'user.irreligious':
      case 'not religious':
        return AppLocalizations.of(context)!.irreligious;
      case 'little_religious':
      case 'user.little_religious':
      case 'little religious':
        return AppLocalizations.of(context)!.littleReligious;
      case 'religious':
      case 'user.religious':
        return AppLocalizations.of(context)!.religious;
      case 'much_religious':
      case 'user.much_religious':
      case 'very religious':
        return AppLocalizations.of(context)!.muchReligious;
      case 'dont_say':
      case 'user.dont_say':
        return AppLocalizations.of(context)!.dontSay;
      default:
        return apiValue;
    }
  }

  /// Helper method to map API prayer values to display values
  String _mapPrayerToDisplay(BuildContext context, String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    // If it's already a display value, return as is
    if (['أصلي دائماً', 'أصلي أغلب الأوقات', 'أصلي أحياناً', 'لا أصلي', 'أفضل ألا أقول'].contains(apiValue)) {
      return apiValue;
    }

    // Map API values to display values
    switch (apiValue.toLowerCase().trim()) {
      case 'always':
      case 'user.always':
        return AppLocalizations.of(context)!.prayAlways;
      case 'most_times':
      case 'user.most_times':
        return AppLocalizations.of(context)!.prayMostTimes;
      case 'sometimes':
      case 'user.sometimes':
        return AppLocalizations.of(context)!.praySometimes;
      case 'no_pray':
      case 'user.no_pray':
        return AppLocalizations.of(context)!.noPray;
      case 'dont_say':
      case 'user.dont_say':
        return AppLocalizations.of(context)!.dontSay;
      default:
        return apiValue;
    }
  }

  /// Helper method to map API beard values to display values
  String _mapBeardToDisplay(BuildContext context, String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    // If it's already a display value, return as is
    if (['ملتحي', 'بدون لحية'].contains(apiValue)) {
      return apiValue;
    }

    // Map API values to display values
    switch (apiValue.toLowerCase().trim()) {
      case 'beard':
      case 'user.beard':
        return AppLocalizations.of(context)!.withBeard;
      case 'without_beard':
      case 'user.without_beard':
        return AppLocalizations.of(context)!.withoutBeard;
      default:
        return apiValue;
    }
  }

  /// Helper method to map API hijab values to display values
  String _mapHijabToDisplay(BuildContext context, String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    // If it's already a display value, return as is
    if (['غير محجبة', 'محجبة (كشف الوجه)', 'محجبة (النقاب)', 'محجبة (غطاء الوجه)', 'أفضل ألا أقول'].contains(apiValue)) {
      return apiValue;
    }

    // Map API values to display values
    switch (apiValue.toLowerCase().trim()) {
      case 'not_hijab':
      case 'user.not_hijab':
        return AppLocalizations.of(context)!.notHijab;
      case 'hijab':
      case 'user.hijab':
        return AppLocalizations.of(context)!.hijabFaceVisible;
      case 'hijab_and_veil':
      case 'user.hijab_and_veil':
        return AppLocalizations.of(context)!.hijabWithVeil;
      case 'hijab_face':
      case 'user.hijab_face':
        return AppLocalizations.of(context)!.hijabFaceCovered;
      case 'dont_say':
      case 'user.dont_say':
        return AppLocalizations.of(context)!.dontSay;
      default:
        return apiValue;
    }
  }
}
