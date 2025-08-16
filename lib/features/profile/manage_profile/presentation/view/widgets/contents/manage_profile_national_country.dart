import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:flutter/material.dart';
import '../manage_profile_content_item.dart';
import '../manage_profile_custom_separator.dart';

class ManageProfileNationalCountry extends StatelessWidget {
  const ManageProfileNationalCountry({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'الجنسية',
          itemContent: _itemContent('السعودية'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الدولة',
          itemContent: _itemContent('السعودية'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'المدينة',
          itemContent: _itemContent('الرياض'),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: () => _showNationalCountryEditDialog(context),
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

  void _showNationalCountryEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل الجنسية والدولة والمدينة',
      fields: [
        ManageProfileField(
          label: 'الجنسية',
          hint: 'اختر الجنسية',
          currentValue: 'السعودية',
          type: ManageProfileFieldType.dropdown,
          options: [
            'السعودية',
            'المصرية',
            'الأردنية',
            'اللبنانية',
            'السورية',
            'العراقية',
            'الكويتية',
            'الإماراتية',
            'القطرية',
            'البحرينية',
            'العمانية',
            'اليمنية',
            'الفلسطينية',
            'السودانية',
            'الجزائرية',
            'المغربية',
            'التونسية',
            'الليبية',
            'الموريتانية',
            'الصومالية',
            'الجيبوتية',
            'القمرية',
          ],
        ),
        ManageProfileField(
          label: 'الدولة',
          hint: 'اختر الدولة',
          currentValue: 'السعودية',
          type: ManageProfileFieldType.dropdown,
          options: [
            'السعودية',
            'مصر',
            'الأردن',
            'لبنان',
            'سوريا',
            'العراق',
            'الكويت',
            'الإمارات',
            'قطر',
            'البحرين',
            'عمان',
            'اليمن',
            'فلسطين',
            'السودان',
            'الجزائر',
            'المغرب',
            'تونس',
            'ليبيا',
            'موريتانيا',
            'الصومال',
            'جيبوتي',
            'جزر القمر',
          ],
        ),
        ManageProfileField(
          label: 'المدينة',
          hint: 'اختر المدينة',
          currentValue: 'الرياض',
          type: ManageProfileFieldType.dropdown,
          options: [
            'الرياض',
            'جدة',
            'مكة المكرمة',
            'المدينة المنورة',
            'الدمام',
            'الخبر',
            'الظهران',
            'تبوك',
            'أبها',
            'جازان',
            'نجران',
            'الباحة',
            'الجوف',
            'حائل',
            'القصيم',
            'عسير',
            'الباحة',
            'جازان',
            'نجران',
            'الجوف',
            'حائل',
            'القصيم',
            'عسير',
          ],
        ),
      ],
      onSave: () {
        // Handle save logic here
        print('Saving national country data...');
      },
    );

    manageProfileDialog(context, dialogData);
  }
}
