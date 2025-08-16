import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';

class ManageProfileMaritalStatus extends StatelessWidget {
  const ManageProfileMaritalStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'حالة الحساب',
          itemContent: _itemContent('مطلقة'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'نوع الزواج',
          itemContent: _itemContent('الزوجة الوحيدة'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'العمر',
          itemContent: _itemContent('23'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الاطفال',
          itemContent: _itemContent('0'),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: () => _showMaritalStatusEditDialog(context),
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

  void _showMaritalStatusEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل الحالة الاجتماعية',
      fields: [
        ManageProfileField(
          label: 'حالة الحساب',
          hint: 'اختر الحالة الاجتماعية',
          currentValue: 'مطلقة',
          type: ManageProfileFieldType.dropdown,
          options: [
            'عزباء',
            'مطلقة',
            'أرملة',
            'متزوجة',
          ],
        ),
        ManageProfileField(
          label: 'نوع الزواج',
          hint: 'اختر نوع الزواج',
          currentValue: 'الزوجة الوحيدة',
          type: ManageProfileFieldType.dropdown,
          options: [
            'الزوجة الوحيدة',
            'لا مانع من تعدد الزوجات',
          ],
        ),
        ManageProfileField(
          label: 'العمر',
          hint: 'أدخل العمر',
          currentValue: '23',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: 'الاطفال',
          hint: 'أدخل عدد الأطفال',
          currentValue: '0',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
      ],
      onSave: () {
        // Handle save logic here
        print('Saving marital status...');
      },
    );

    manageProfileDialog(context, dialogData);
  }
}
