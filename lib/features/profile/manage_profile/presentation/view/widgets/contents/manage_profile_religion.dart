import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';

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
            text: profileData?.attribute?.smoking ?? '',
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
    final dialogData = ManageProfileDialogData(
      title: 'تعديل المعلومات الدينية',
      fields: [
        ManageProfileField(
          label: 'الإلتزام الديني',
          hint: 'اختر مستوى الالتزام الديني',
          currentValue: profileData?.attribute?.religiousCommitment ?? '',
          type: ManageProfileFieldType.dropdown,
          options: [
            'غير متدينة',
            'متدينة قليلا',
            'متدينة',
            'متدينة كثرا',
            'متدينة جدا',
          ],
        ),
        ManageProfileField(
          label: 'الصلاة',
          hint: 'اختر حالة الصلاة',
          currentValue: profileData?.attribute?.prayer ?? '',
          type: ManageProfileFieldType.dropdown,
          options: [
            'اصلي دائما',
            'اصلي احيانا',
            'لا اصلي',
          ],
        ),
        ManageProfileField(
          label: 'التدخين',
          hint: 'اختر حالة التدخين',
          currentValue: profileData?.attribute?.smoking ?? '',
          type: ManageProfileFieldType.dropdown,
          options: [
            'نعم',
            'لأ',
          ],
        ),
        ManageProfileField(
          label: 'الحجاب',
          hint: 'اختر حالة الحجاب',
          currentValue: profileData?.attribute?.hijab ?? '',
          type: ManageProfileFieldType.dropdown,
          options: [
            'محجبة',
            'محجبة (النقاب)',
            'غير محجبة',
            'افضل ان اقول لا',
          ],
        ),
      ],
      onSave: () {
        // Handle save logic here
        print('Saving religion data...');
      },
    );

    manageProfileDialog(context, dialogData);
  }
}
