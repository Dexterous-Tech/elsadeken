import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';

class ManageProfileReligion extends StatelessWidget {
  const ManageProfileReligion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'الإلتزام الديني',
          itemContent: _itemContent('متدينة كثرا'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الصلاة',
          itemContent: _itemContent('اصلي دائما'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'التدخين',
          itemContent: _itemContent('لأ'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الحجاب',
          itemContent: _itemContent('افضل ان اقول لا'),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: () => _showReligionEditDialog(context),
        )
      ],
    );
  }

  Widget _itemContent(String title) {
    return Text(
      title,
      style: AppTextStyles.font18PhilippineBronzeRegularPlexSans,
    );
  }

  void _showReligionEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل المعلومات الدينية',
      fields: [
        ManageProfileField(
          label: 'الإلتزام الديني',
          hint: 'اختر مستوى الالتزام الديني',
          currentValue: 'متدينة كثرا',
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
          currentValue: 'اصلي دائما',
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
          currentValue: 'لأ',
          type: ManageProfileFieldType.dropdown,
          options: [
            'نعم',
            'لأ',
          ],
        ),
        ManageProfileField(
          label: 'الحجاب',
          hint: 'اختر حالة الحجاب',
          currentValue: 'افضل ان اقول لا',
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
