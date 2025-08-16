import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:flutter/material.dart';
import '../manage_profile_content_item.dart';
import '../manage_profile_custom_separator.dart';

class ManageProfileNationalCountry extends StatelessWidget {
  const ManageProfileNationalCountry({
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
          title: 'الجنسية',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.nationality ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الدولة',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.country ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'المدينة',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.city ?? '',
            isLoading: isLoading,
          ),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed:
              isLoading ? null : () => _showNationalCountryEditDialog(context),
        )
      ],
    );
  }

  void _showNationalCountryEditDialog(BuildContext context) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل الجنسية والدولة والمدينة',
      fields: [
        ManageProfileField(
          label: 'الجنسية',
          hint: 'اختر الجنسية',
          currentValue: profileData?.attribute?.nationality ?? '',
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
          currentValue: profileData?.attribute?.country ?? '',
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
          currentValue: profileData?.attribute?.city ?? '',
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
