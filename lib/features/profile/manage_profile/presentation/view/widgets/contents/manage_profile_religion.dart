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
          currentValue: profileData?.attribute?.religiousCommitment ?? '',
          type: ManageProfileFieldType.dropdown,
          options: [
            'غير متدين',
            'متدين قليلا',
            'متدين',
          ],
        ),
        ManageProfileField(
          label: 'الصلاة',
          hint: 'اختر حالة الصلاة',
          currentValue: profileData?.attribute?.prayer ?? '',
          type: ManageProfileFieldType.dropdown,
          options: [
            'اصلي دائما',
            'اصلي اغلب الاوقات',
            'لا اصلي',
          ],
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
        ManageProfileField(
          label: 'الحجاب',
          hint: 'اختر حالة الحجاب',
          currentValue: profileData?.attribute?.hijab ?? '',
          type: ManageProfileFieldType.dropdown,
          options: [
            'محجبه',
            'محجبه (النقاب)',
            'غير محجبه',
          ],
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
}
