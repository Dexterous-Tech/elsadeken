import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageProfileLoginData extends StatelessWidget {
  const ManageProfileLoginData({
    super.key,
    this.profileData,
    this.isLoading = false,
  });

  final MyProfileDataModel? profileData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: LocalizationService.instance.textDirection,
      children: [
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.membershipNumber,
          itemContent: ManageProfileContentText(
            text: profileData?.id?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.username,
          itemContent: ManageProfileContentText(
            text: profileData?.name ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.phoneNumber,
          itemContent: ManageProfileContentText(
            text: profileData?.phone ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.registrationDate,
          itemContent: ManageProfileContentText(
            text: _formatDate(context, profileData?.createdAt),
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.password,
          itemContent: ManageProfileContentText(
            text: '**********',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: AppLocalizations.of(context)!.email,
          itemContent: ManageProfileContentText(
            text: profileData?.email ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: isLoading ? null : () => _showLoginDataEditDialog(context),
        )
      ],
    );
  }

  String _formatDate(BuildContext context, String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return AppLocalizations.of(context)!.today;
      } else if (difference.inDays == 1) {
        return AppLocalizations.of(context)!.oneDayAgo;
      } else if (difference.inDays < 7) {
        return AppLocalizations.of(context)!.daysAgo(difference.inDays.toString());
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return AppLocalizations.of(context)!.weeksAgo(weeks.toString());
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return AppLocalizations.of(context)!.monthsAgo(months.toString());
      } else {
        final years = (difference.inDays / 365).floor();
        return AppLocalizations.of(context)!.yearsAgo(years.toString());
      }
    } catch (e) {
      return dateString;
    }
  }

  void _showLoginDataEditDialog(BuildContext context) {
    final updateProfileCubit = context.read<UpdateProfileCubit>();

    final dialogData = ManageProfileDialogData(
      title: AppLocalizations.of(context)!.editLoginData,
      cubit: updateProfileCubit,
      signUpListsCubit: null, // Login data doesn't need SignUpListsCubit
      dialogType: ManageProfileDialogType.loginData,
      fields: [
        ManageProfileField(
          label: AppLocalizations.of(context)!.username,
          hint: AppLocalizations.of(context)!.enterUsername,
          currentValue: profileData?.name ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.text,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.phoneNumber,
          hint: AppLocalizations.of(context)!.enterPhoneNumber,
          currentValue: profileData?.phone ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.phone,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.email,
          hint: AppLocalizations.of(context)!.enterEmail,
          currentValue: profileData?.email ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.emailAddress,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.newPassword,
          hint: AppLocalizations.of(context)!.enterNewPassword,
          currentValue: '',
          type: ManageProfileFieldType.password,
          isRequired: false,
        ),
        ManageProfileField(
          label: AppLocalizations.of(context)!.confirmPassword,
          hint: AppLocalizations.of(context)!.enterConfirmPassword,
          currentValue: '',
          type: ManageProfileFieldType.password,
          isRequired: false,
        ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }
}
