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
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'الحالة الاجتماعية',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.maritalStatus ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'نوع الزواج',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.typeOfMarriage ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'العمر',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.age?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الاطفال',
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

    final dialogData = ManageProfileDialogData(
      title: 'تعديل الحالة الاجتماعية',
      cubit: updateProfileCubit,
      signUpListsCubit: null, // Marital status doesn't need SignUpListsCubit
      dialogType: ManageProfileDialogType.socialStatus,
      fields: [
        ManageProfileField(
          label: 'الحالة الاجتماعية',
          hint: 'اختر الحالة الاجتماعية',
          currentValue: profileData?.attribute?.maritalStatus ?? '',
          type: ManageProfileFieldType.dropdown,
          options: _isMale(profileData?.gender)
              ? [
                  'عازب',
                  'متزوج',
                  'مطلق',
                  'أرمل',
                ]
              : [
                  'آنسة',
                  'متزوجة',
                  'مطلقة',
                  'أرملة',
                ],
        ),
        ManageProfileField(
          label: 'نوع الزواج',
          hint: 'اختر نوع الزواج',
          currentValue: profileData?.attribute?.typeOfMarriage ?? '',
          type: ManageProfileFieldType.dropdown,
          options: _isMale(profileData?.gender)
              ? [
                  'زوجة اولي',
                  'زوجة ثانية',
                ]
              : [
                  'الزوج الوحيد',
                  'لا مانع من تعدل الزوجات',
                ],
        ),
        ManageProfileField(
          label: 'العمر',
          hint: 'أدخل العمر',
          currentValue: profileData?.attribute?.age?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: 'عدد الأطفال',
          hint: 'أدخل عدد الأطفال',
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
}
