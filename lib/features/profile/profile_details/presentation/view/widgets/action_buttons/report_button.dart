import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/report_dialog.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final int userId;
  final UsersDataModel? currentUser;
  final VoidCallback? onUserStateChanged;

  const ReportButton({
    super.key,
    required this.userId,
    this.currentUser,
    this.onUserStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isReported = currentUser?.isReported ?? false;
    // final isBlocked = currentUser?.isBlocked ?? false;

    // if (isReported) {
    //   return _buildDisabledButton(
    //     context,
    //     AppImages.block,
    //     AppLocalizations.of(context)!.cancelReport,
    //     () =>
    //   );
    // }

    return CustomContainer(
      img: AppImages.block,
      text: isReported
          ? AppLocalizations.of(context)!.cancelReport
          : AppLocalizations.of(context)!.report,
      onTap: () => isReported
          ? _showReportDialog(context, true)
          : _showReportDialog(context, false),
    );
  }

  void _showReportDialog(BuildContext context, bool isReported) {
    if (isReported) {
      reportDialog(
        afterSuccess: () => onUserStateChanged?.call(),
        context: context,
        userId: userId,
        isReported: isReported,
        question: AppLocalizations.of(context)!.sureUnreportedQu,
        questionButton: AppLocalizations.of(context)!.cancelReport,
      );
    } else {
      reportDialog(
        afterSuccess: () => onUserStateChanged?.call(),
        context: context,
        userId: userId,
      );
    }
  }
}
