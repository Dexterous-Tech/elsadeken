import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';

class ManageProfileAppearance extends StatelessWidget {
  const ManageProfileAppearance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'الزون(كغ)',
          itemContent: _itemContent('60'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الطول(سم)',
          itemContent: _itemContent('166'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'لون البشرة',
          itemContent: _itemContent('حنطي مائل للبياض'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'بنية الجسم',
          itemContent: _itemContent('سمينة'),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: () => _showAppearanceEditDialog(context),
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

  void _showAppearanceEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل المظهر الخارجي',
      fields: [
        ManageProfileField(
          label: 'الزون(كغ)',
          hint: 'أدخل الوزن بالكيلوغرام',
          currentValue: '60',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: 'الطول(سم)',
          hint: 'أدخل الطول بالسنتيمتر',
          currentValue: '166',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: 'لون البشرة',
          hint: 'اختر لون البشرة',
          currentValue: 'حنطي مائل للبياض',
          type: ManageProfileFieldType.dropdown,
          options: [
            'أبيض',
            'أسمر',
            'حنطي مائل للبياض',
            'حنطي مائل للسمرة',
            'أسود',
            'أشقر',
          ],
        ),
        ManageProfileField(
          label: 'بنية الجسم',
          hint: 'اختر بنية الجسم',
          currentValue: 'سمينة',
          type: ManageProfileFieldType.dropdown,
          options: [
            'نحيفة',
            'متوسطة',
            'سمينة',
            'رياضية',
            'ممتلئة',
          ],
        ),
      ],
      onSave: () {
        // Handle save logic here
        print('Saving appearance data...');
      },
    );

    manageProfileDialog(context, dialogData);
  }
}
