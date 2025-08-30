import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/theme/spacing.dart';
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
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ManageProfileContentItem(
          title: 'الإلتزام الديني',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.religiousCommitment ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الصلاة',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.prayer ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'التدخين',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.smoking?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        // Show beard for males only
        if (profileData?.gender == 'male' || profileData?.gender == 'ذكر')
          ManageProfileContentItem(
            title: 'اللحية',
            itemContent: ManageProfileContentText(
              text: profileData?.attribute?.beard ?? '',
              isLoading: isLoading,
            ),
          ),
        // Show hijab for females only
        if (profileData?.gender == 'female' || profileData?.gender == 'أنثى')
          ManageProfileContentItem(
            title: 'الحجاب',
            itemContent: ManageProfileContentText(
              text: profileData?.attribute?.hijab ?? '',
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
      title: 'تعديل المعلومات الدينية',
      cubit: updateProfileCubit,
      signUpListsCubit: null, // No lists needed for religious data
      dialogType: ManageProfileDialogType.religion,
      fields: [
        ManageProfileField(
          label: 'الإلتزام الديني',
          hint: 'اختر مستوى الالتزام الديني',
          currentValue: _mapReligionToDisplay(
              profileData?.attribute?.religiousCommitment),
          type: ManageProfileFieldType.dropdown,
          options: religionOptions.values.toList(),
        ),
        ManageProfileField(
          label: 'الصلاة',
          hint: 'اختر حالة الصلاة',
          currentValue: _mapPrayerToDisplay(profileData?.attribute?.prayer),
          type: ManageProfileFieldType.dropdown,
          options: prayerOptions.values.toList(),
        ),
        ManageProfileField(
          label: 'التدخين',
          hint: 'اختر حالة التدخين',
          currentValue:
              _getSmokingDisplayValue(profileData?.attribute?.smoking),
          type: ManageProfileFieldType.dropdown,
          options: [
            'نعم',
            'لا',
          ],
        ),
        // Show beard for males only
        if (profileData?.gender == 'male' || profileData?.gender == 'ذكر')
          ManageProfileField(
            label: 'اللحية',
            hint: 'اختر حالة اللحية',
            currentValue: _mapBeardToDisplay(profileData?.attribute?.beard),
            type: ManageProfileFieldType.dropdown,
            options: beardOptions.values.toList(),
          ),
        // Show hijab for females only
        if (profileData?.gender == 'female' || profileData?.gender == 'أنثى')
          ManageProfileField(
            label: 'الحجاب',
            hint: 'اختر حالة الحجاب',
            currentValue: _mapHijabToDisplay(profileData?.attribute?.hijab),
            type: ManageProfileFieldType.dropdown,
            options: scarfOptions.values.toList(),
          ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }

  /// Helper method to convert smoking API value to display text
  String _getSmokingDisplayValue(String? smoking) {
    if (smoking == null || smoking.isEmpty) return '';

    // Handle both string and numeric values
    if (smoking == '1' || smoking == 'نعم') return 'نعم';
    if (smoking == '0' || smoking == 'لا') return 'لا';

    // Default case
    return '';
  }

  /// Religion options mapping
  Map<String, String> get religionOptions {
    return {
      'irreligious': 'غير متدين',
      'little_religious': 'متدين قليلا',
      'religious': 'متدين',
      'much_religious': 'متدين كثيرا',
      'dont_say': 'أفضل الا اقول',
    };
  }

  /// Prayer options mapping
  Map<String, String> get prayerOptions {
    return {
      'always': 'اصلي دائما',
      'most_times': 'اصلي اغلب الاوقات',
      'sometimes': 'اصلي بعض الاحيان',
      'no_pray': 'لا اصلي',
      'dont_say': 'أفضل الا اقول',
    };
  }

  /// Beard options mapping
  Map<String, String> get beardOptions {
    return {
      'beard': 'ملتحي',
      'without_beard': 'بدون لحية',
    };
  }

  /// Scarf/Hijab options mapping
  Map<String, String> get scarfOptions {
    return {
      'not_hijab': 'غير محجبه',
      'hijab': 'محجبه(كشف الوجه)',
      'hijab_and_veil': 'محجبه (النقاب)',
      'hijab_face': 'محجبه (غطاء الوجه)',
      'dont_say': 'افضل الا اقول',
    };
  }

  /// Helper method to map API religion values to display values
  String _mapReligionToDisplay(String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();

    // Check if the value is already in Arabic (display format)
    if (religionOptions.values.contains(value)) {
      return value;
    }

    // Map API values to display values
    return religionOptions[value] ?? value;
  }

  /// Helper method to map API prayer values to display values
  String _mapPrayerToDisplay(String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();

    // Check if the value is already in Arabic (display format)
    if (prayerOptions.values.contains(value)) {
      return value;
    }

    // Map API values to display values
    return prayerOptions[value] ?? value;
  }

  /// Helper method to map API beard values to display values
  String _mapBeardToDisplay(String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();

    // Check if the value is already in Arabic (display format)
    if (beardOptions.values.contains(value)) {
      return value;
    }

    // Map API values to display values
    return beardOptions[value] ?? value;
  }

  /// Helper method to map API hijab values to display values
  String _mapHijabToDisplay(String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return '';

    final value = apiValue.trim();

    // Check if the value is already in Arabic (display format)
    if (scarfOptions.values.contains(value)) {
      return value;
    }

    // Map API values to display values
    return scarfOptions[value] ?? value;
  }
}
