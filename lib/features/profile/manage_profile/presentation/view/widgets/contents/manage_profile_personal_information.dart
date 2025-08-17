import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';

class ManageProfilePersonalInformation extends StatelessWidget {
  const ManageProfilePersonalInformation({
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
          title: 'الإسم الكامل',
          itemContent: ManageProfileContentText(
            text: profileData?.name ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'رقم الهاتف',
          itemContent: ManageProfileContentText(
            text: profileData?.phone ?? '',
            isLoading: isLoading,
          ),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed:
              isLoading ? null : () => _showPersonalInfoEditDialog(context),
        )
      ],
    );
  }

  void _showPersonalInfoEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل المعلومات الشخصية',
      fields: [
        ManageProfileField(
          label: 'الإسم الكامل',
          hint: 'أدخل الإسم الكامل',
          currentValue: profileData?.name ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.text,
        ),
        ManageProfileField(
          label: 'رقم الهاتف',
          hint: 'أدخل رقم الهاتف',
          currentValue: profileData?.phone ?? '',
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
