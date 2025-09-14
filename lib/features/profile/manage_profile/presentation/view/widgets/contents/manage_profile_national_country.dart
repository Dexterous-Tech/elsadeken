import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      textDirection: LocalizationService.instance.textDirection,
      children: [
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.nationality,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.nationality ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.country,
          itemContent: ManageProfileContentText(
            text: profileData?.attribute?.country ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.city,
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
    final updateProfileCubit = context.read<UpdateProfileCubit>();
    final signUpListsCubit = context.read<SignUpListsCubit>();

    final dialogData = ManageProfileDialogData(
      title: AppLocalizations.of(context)!.editNationalityCountryCity,
      cubit: updateProfileCubit,
      signUpListsCubit: signUpListsCubit,
      dialogType: ManageProfileDialogType.nationalCountry,
      fields: [
        ManageProfileField(
          label: AppLocalizations.of(context)!.nationality,
          hint: AppLocalizations.of(context)!.chooseNationality,
          currentValue: profileData?.attribute?.nationality ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.nationality,
          isRequired: false, // Make optional
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.country,
          hint: AppLocalizations.of(context)!.chooseCountry,
          currentValue: profileData?.attribute?.country ?? '',
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.country,
          isRequired: false, // Make optional
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.city,
          hint: AppLocalizations.of(context)!.chooseCity,
          currentValue:
              profileData?.attribute?.city ?? '', // Show current user city
          type: ManageProfileFieldType.dropdown,
          dataType: ManageProfileFieldDataType.city,
          dependentFieldLabel: AppLocalizations.of(context)!
              .country, // Cities depend on country selection
          isRequired: false, // Make optional
        ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }
}
