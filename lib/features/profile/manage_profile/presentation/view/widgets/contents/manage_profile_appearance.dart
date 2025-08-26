import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';

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
          title: 'الوزن(كغ)',
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
    final updateProfileCubit = context.read<UpdateProfileCubit>();
    final signUpListsCubit = context.read<SignUpListsCubit>();

    final dialogData = ManageProfileDialogData(
      title: 'تعديل المظهر الخارجي',
      cubit: updateProfileCubit,
      signUpListsCubit: signUpListsCubit,
      dialogType: ManageProfileDialogType.bodyInfo,
      fields: [
        ManageProfileField(
          label: 'الوزن',
          hint: 'أدخل الوزن بالكيلوغرام',
          currentValue: profileData?.attribute?.weight?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: 'الطول',
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
          dataType: ManageProfileFieldDataType.skinColor,
        ),
        ManageProfileField(
          label: 'البنية الجسدية',
          hint: 'اختر البنية الجسدية',
          currentValue: profileData?.attribute?.physique ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.physique,
        ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }
}
