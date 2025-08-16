import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';

class ManageProfileAppearance extends StatelessWidget {
  const ManageProfileAppearance({
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
          title: 'الزون(كغ)',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.weight?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الطول(سم)',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.height?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'لون البشرة',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.skinColor ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'بنية الجسم',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.physique ?? '',
            isLoading: isLoading,
          ),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed:
              isLoading ? null : () => _showAppearanceEditDialog(context),
        )
      ],
    );
  }

  void _showAppearanceEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل المظهر الخارجي',
      fields: [
        ManageProfileField(
          label: 'الزون(كغ)',
          hint: 'أدخل الوزن بالكيلوغرام',
          currentValue: profileData?.attribute?.weight?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: 'الطول(سم)',
          hint: 'أدخل الطول بالسنتيمتر',
          currentValue: profileData?.attribute?.height?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: 'لون البشرة',
          hint: 'اختر لون البشرة',
          currentValue: profileData?.attribute?.skinColor ?? '',
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
          currentValue: profileData?.attribute?.physique ?? '',
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
