import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:flutter/material.dart';

class ManageProfileLoginData extends StatelessWidget {
  const ManageProfileLoginData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'رقم العضوية',
          itemContent: _itemContent('12345678'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'اسم المستخدم',
          itemContent: _itemContent('Esraa Mohamed'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'تاريخ التسجيل',
          itemContent: _itemContent('منذ 2 ايام'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'كلمة المرور',
          itemContent: _itemContent('**********'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'البريد الإلكتروني',
          itemContent: _itemContent('mohames@gmail.com'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'حذف حسابي',
          itemContent: Text(
            'حذف',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans
                .copyWith(color: AppColors.vividRed),
          ),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: () => _showLoginDataEditDialog(context),
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

  void _showLoginDataEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل بيانات تسجيل الدخول',
      fields: [
        ManageProfileField(
          label: 'اسم المستخدم',
          hint: 'أدخل اسم المستخدم',
          currentValue: 'Esraa Mohamed',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.text,
        ),
        ManageProfileField(
          label: 'البريد الإلكتروني',
          hint: 'أدخل البريد الإلكتروني',
          currentValue: 'mohames@gmail.com',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.emailAddress,
        ),
        ManageProfileField(
          label: 'كلمة المرور',
          hint: 'أدخل كلمة المرور الجديدة',
          currentValue: '',
          type: ManageProfileFieldType.password,
        ),
      ],
      onSave: () {
        // Handle save logic here
        print('Saving login data...');
      },
    );

    manageProfileDialog(context, dialogData);
  }
}
