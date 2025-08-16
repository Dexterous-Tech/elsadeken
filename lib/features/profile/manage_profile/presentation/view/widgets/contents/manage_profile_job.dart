import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';

class ManageProfileJob extends StatelessWidget {
  const ManageProfileJob({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'المؤهل التعليمي ',
          itemContent: _itemContent('دراسة جامعية'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الوضع المادي',
          itemContent: _itemContent('متوسط'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'مجال العمل',
          itemContent: _itemContent('مجال النقل'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الوظيفة',
          itemContent: Text(
            'مبرمجة',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الدخل الشهري',
          itemContent: _itemContent('أقل من 2000 ريال'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الحالة الصحية',
          itemContent: _itemContent('بهاق'),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: () => _showJobEditDialog(context),
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

  void _showJobEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل المعلومات المهنية',
      fields: [
        ManageProfileField(
          label: 'المؤهل التعليمي',
          hint: 'اختر المؤهل التعليمي',
          currentValue: 'دراسة جامعية',
          type: ManageProfileFieldType.dropdown,
          options: [
            'ابتدائي',
            'متوسط',
            'ثانوي',
            'دراسة جامعية',
            'ماجستير',
            'دكتوراه',
          ],
        ),
        ManageProfileField(
          label: 'الوضع المادي',
          hint: 'اختر الوضع المادي',
          currentValue: 'متوسط',
          type: ManageProfileFieldType.dropdown,
          options: [
            'ضعيف',
            'متوسط',
            'جيد',
            'ممتاز',
          ],
        ),
        ManageProfileField(
          label: 'مجال العمل',
          hint: 'اختر مجال العمل',
          currentValue: 'مجال النقل',
          type: ManageProfileFieldType.dropdown,
          options: [
            'مجال النقل',
            'مجال الصحة',
            'مجال التعليم',
            'مجال التجارة',
            'مجال التكنولوجيا',
            'مجال الزراعة',
            'مجال الصناعة',
            'مجال الخدمات',
          ],
        ),
        ManageProfileField(
          label: 'الوظيفة',
          hint: 'أدخل الوظيفة',
          currentValue: 'مبرمجة',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.text,
        ),
        ManageProfileField(
          label: 'الدخل الشهري',
          hint: 'اختر الدخل الشهري',
          currentValue: 'أقل من 2000 ريال',
          type: ManageProfileFieldType.dropdown,
          options: [
            'أقل من 2000 ريال',
            '2000-5000 ريال',
            '5000-10000 ريال',
            '10000-20000 ريال',
            'أكثر من 20000 ريال',
          ],
        ),
        ManageProfileField(
          label: 'الحالة الصحية',
          hint: 'اختر الحالة الصحية',
          currentValue: 'بهاق',
          type: ManageProfileFieldType.dropdown,
          options: [
            'ممتازة',
            'جيدة',
            'متوسطة',
            'ضعيفة',
            'بهاق',
            'سكري',
            'ضغط',
            'أخرى',
          ],
        ),
      ],
      onSave: () {
        // Handle save logic here
        print('Saving job data...');
      },
    );

    manageProfileDialog(context, dialogData);
  }
}
