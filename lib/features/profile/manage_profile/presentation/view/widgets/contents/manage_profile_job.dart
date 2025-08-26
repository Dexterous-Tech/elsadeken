import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';

import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';

class ManageProfileJob extends StatelessWidget {
  const ManageProfileJob({
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
          title: 'المؤهل التعليمي ',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.qualification ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الوضع المادي',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.financialSituation ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'مجال العمل',
          itemContent: ManageProfileContentText(
            text:
                'مجال النقل', // This field is not in the model, keeping default
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الوظيفة',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.job ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الدخل الشهري',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.income?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الحالة الصحية',
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.healthCondition ?? '',
            isLoading: isLoading,
          ),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: isLoading ? null : () => _showJobEditDialog(context),
        )
      ],
    );
  }

  void _showJobEditDialog(BuildContext context) {
    final updateProfileCubit = context.read<UpdateProfileCubit>();
    final signUpListsCubit = context.read<SignUpListsCubit>();

    final dialogData = ManageProfileDialogData(
      title: 'تعديل المعلومات المهنية',
      cubit: updateProfileCubit,
      signUpListsCubit: signUpListsCubit,
      dialogType: ManageProfileDialogType.job,
      fields: [
        ManageProfileField(
          label: 'المؤهل التعليمي',
          hint: 'اختر المؤهل التعليمي',
          currentValue: profileData?.attribute?.qualification ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.qualification,
        ),
        ManageProfileField(
          label: 'الوضع المادي',
          hint: 'اختر الوضع المادي',
          currentValue: profileData?.attribute?.financialSituation ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.financialSituation,
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
          currentValue: profileData?.attribute?.job ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.text,
        ),
        ManageProfileField(
          label: 'الدخل الشهري',
          hint: 'اختر الدخل الشهري',
          currentValue: profileData?.attribute?.income?.toString() ?? '',
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
          currentValue: profileData?.attribute?.healthCondition ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.healthCondition,
        ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }
}
