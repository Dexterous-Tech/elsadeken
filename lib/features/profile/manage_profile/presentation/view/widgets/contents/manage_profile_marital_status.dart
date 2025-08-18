import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';

class ManageProfileMaritalStatus extends StatelessWidget {
  const ManageProfileMaritalStatus({
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
          title: 'حالة الحساب',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.maritalStatus ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'نوع الزواج',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.typeOfMarriage ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'العمر',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.age?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الاطفال',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.children?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed:
              isLoading ? null : () => _showMaritalStatusEditDialog(context),
        )
      ],
    );
  }

  void _showMaritalStatusEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل الحالة الاجتماعية',
      fields: [
        ManageProfileField(
          label: 'حالة الحساب',
          hint: 'اختر الحالة الاجتماعية',
          currentValue: profileData?.attribute?.maritalStatus ?? '',
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
          currentValue: profileData?.attribute?.typeOfMarriage ?? '',
          type: ManageProfileFieldType.dropdown,
          options: [
            'الزوجة الوحيدة',
            'لا مانع من تعدد الزوجات',
          ],
        ),
        ManageProfileField(
          label: 'العمر',
          hint: 'أدخل العمر',
          currentValue: profileData?.attribute?.age?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: 'الاطفال',
          hint: 'أدخل عدد الأطفال',
          currentValue: profileData?.attribute?.children?.toString() ?? '',
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
