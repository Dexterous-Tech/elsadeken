import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

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
      textDirection: LocalizationService.instance.textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.weightKg,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.weight?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.heightCm,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.height?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.skinColor,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.skinColor ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.bodyStructure,
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
      title: AppLocalizations.of(context)!.editPhysicalAppearance,
      cubit: updateProfileCubit,
      signUpListsCubit: signUpListsCubit,
      dialogType: ManageProfileDialogType.bodyInfo,
      fields: [
        ManageProfileField(
          label: AppLocalizations.of(context)!.weight,
          hint: AppLocalizations.of(context)!.enterWeightInKg,
          currentValue: profileData?.attribute?.weight?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.height,
          hint: AppLocalizations.of(context)!.enterHeightInCm,
          currentValue: profileData?.attribute?.height?.toString() ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.number,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.skinColor,
          hint: AppLocalizations.of(context)!.chooseSkinColor,
          currentValue: profileData?.attribute?.skinColor ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.skinColor,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.physique,
          hint: AppLocalizations.of(context)!.chooseBodyStructure,
          currentValue: profileData?.attribute?.physique ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.physique,
        ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }
}
