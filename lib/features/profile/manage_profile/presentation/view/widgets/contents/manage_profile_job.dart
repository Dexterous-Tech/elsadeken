import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';

import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

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
      textDirection: LocalizationService.instance.textDirection,
      children: [
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.educationalQualification,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.qualification ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.financialStatus,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.financialSituation ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.job,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.job ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.monthlyIncome,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.income?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.healthStatus,
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
      title: AppLocalizations.of(context)!.editProfessionalInfo,
      cubit: updateProfileCubit,
      signUpListsCubit: signUpListsCubit,
      dialogType: ManageProfileDialogType.job,
      fields: [
        ManageProfileField(
          label: AppLocalizations.of(context)!.educationalQualification,
          hint: AppLocalizations.of(context)!.chooseEducationalQualification,
          currentValue: profileData?.attribute?.qualification ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.qualification,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.financialStatus,
          hint: AppLocalizations.of(context)!.chooseFinancialStatus,
          currentValue: profileData?.attribute?.financialSituation ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.financialSituation,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.job,
          hint: AppLocalizations.of(context)!.enterJob,
          currentValue: profileData?.attribute?.job ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.text,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.monthlyIncome,
          hint: AppLocalizations.of(context)!.enterMonthlyIncome,
          currentValue: profileData?.attribute?.income?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.healthStatus,
          hint: AppLocalizations.of(context)!.chooseHealthStatus,
          currentValue: profileData?.attribute?.healthCondition ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.healthCondition,
        ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }
}
