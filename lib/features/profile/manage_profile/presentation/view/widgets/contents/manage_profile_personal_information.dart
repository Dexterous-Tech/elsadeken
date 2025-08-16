import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';

class ManageProfilePersonalInformation extends StatelessWidget {
  const ManageProfilePersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'الإسم الكامل',
          itemContent: _itemContent('ملك محمد'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'رقم الهاتف',
          itemContent: _itemContent('0122356666'),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: () => _showPersonalInfoEditDialog(context),
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

  void _showPersonalInfoEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل المعلومات الشخصية',
      fields: [
        ManageProfileField(
          label: 'الإسم الكامل',
          hint: 'أدخل الإسم الكامل',
          currentValue: 'ملك محمد',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.text,
        ),
        ManageProfileField(
          label: 'رقم الهاتف',
          hint: 'أدخل رقم الهاتف',
          currentValue: '0122356666',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.phone,
        ),
      ],
      onSave: () {
        // Handle save logic here
        print('Saving personal information...');
      },
    );

    manageProfileDialog(context, dialogData);
  }
}
