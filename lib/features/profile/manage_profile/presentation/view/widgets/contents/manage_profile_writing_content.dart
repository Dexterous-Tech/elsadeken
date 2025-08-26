import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProfileWritingContent extends StatelessWidget {
  const ManageProfileWritingContent({
    super.key,
    required this.label,
    this.profileData,
    this.isLoading = false,
  });

  final String label;
  final MyProfileDataModel? profileData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Determine which field to use based on the label
    final isLifePartner = label.contains('شريكة حياتك');
    final content = isLifePartner
        ? profileData?.attribute?.lifePartner ?? ''
        : profileData?.attribute?.aboutMe ?? '';

    return Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        verticalSpace(9),
        Container(
          width: 301.w,
          // height: 155,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: AppColors.white,
          ),
          child: ManageProfileContentText(
            text: content,
            isLoading: isLoading,
            textStyle: AppTextStyles.font18PhilippineBronzeRegularLamaSans,
          ),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: isLoading
              ? null
              : () => _showWritingContentEditDialog(context, label),
        )
      ],
    );
  }

  void _showWritingContentEditDialog(BuildContext context, String label) {
    final updateProfileCubit = context.read<UpdateProfileCubit>();

    // Determine which field to use based on the label
    final isLifePartner = label.contains('شريكة حياتك');
    final currentValue = isLifePartner
        ? profileData?.attribute?.lifePartner ?? ''
        : profileData?.attribute?.aboutMe ?? '';

    // Create separate fields for about me and life partner
    final fields = <ManageProfileField>[];

    if (isLifePartner) {
      fields.add(
        ManageProfileField(
          label: 'شريك الحياة',
          hint: 'اكتب عن مواصفات شريك حياتك',
          currentValue: currentValue,
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
        ),
      );
    } else {
      fields.add(
        ManageProfileField(
          label: 'نبذة عني',
          hint: 'اكتب عن نفسك',
          currentValue: currentValue,
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
        ),
      );
    }

    final dialogData = ManageProfileDialogData(
      title: 'تعديل المحتوى المكتوب',
      cubit: updateProfileCubit,
      signUpListsCubit: null, // No lists needed for text fields
      dialogType: ManageProfileDialogType.descriptions,
      fields: fields,
    );

    manageProfileDialog(context, dialogData);
  }
}
