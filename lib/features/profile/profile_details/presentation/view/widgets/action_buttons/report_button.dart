import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/report_dialog.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final int userId;
  final UsersDataModel? currentUser;

  const ReportButton({
    super.key,
    required this.userId,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final isReported = currentUser?.isReported ?? false;
    final isBlocked = currentUser?.isBlocked ?? false;

    if (isReported) {
      return _buildDisabledButton(
        context,
        AppImages.block,
        AppLocalizations.of(context)!.cancelReport,
        () => _showReportDialog(context, true),
      );
    }

    return CustomContainer(
      img: AppImages.block,
      text: isBlocked
          ? AppLocalizations.of(context)!.reported
          : AppLocalizations.of(context)!.report,
      onTap: () => _showReportDialog(context, false),
    );
  }

  Widget _buildDisabledButton(
    BuildContext context,
    String image,
    String text,
    VoidCallback? onTap,
  ) {
    return Opacity(
      opacity: 0.3,
      child: CustomContainer(
        img: image,
        text: text,
        onTap: onTap,
      ),
    );
  }

  void _showReportDialog(BuildContext context, bool isReported) {
    if (isReported) {
      reportDialog(
        context: context,
        userId: userId,
        isReported: isReported,
        question: AppLocalizations.of(context)!.sureUnreportedQu,
        questionButton: AppLocalizations.of(context)!.cancelReport,
      );
    } else {
      reportDialog(
        context: context,
        userId: userId,
      );
    }
  }
}
