import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/ignore_dialog.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/report_dialog.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class IgnoreButton extends StatelessWidget {
  final int userId;
  final UsersDataModel? currentUser;
  final VoidCallback? onUserStateChanged;
  final VoidCallback? onUserStateChangedReported;

  const IgnoreButton({
    super.key,
    required this.userId,
    this.currentUser,
    this.onUserStateChanged,
    this.onUserStateChangedReported,
  });

  @override
  Widget build(BuildContext context) {
    final isReported = currentUser?.isReported ?? false;
    final isBlocked = currentUser?.isBlocked ?? false;
    final isFavorite = currentUser?.isFavorite ?? false;
    final isIgnored = currentUser?.isIgnore ?? false;

    if (isReported) {
      return _buildDisabledButton(
        context,
        AppImages.thumbDown,
        AppLocalizations.of(context)!.ignore,
        () => _showReportDialog(context, true),
      );
    }

    if (isBlocked) {
      return _buildDisabledButton(
        context,
        AppImages.thumbDown,
        AppLocalizations.of(context)!.ignore,
        null,
      );
    }

    if (isFavorite) {
      return _buildDisabledButton(
        context,
        AppImages.thumbDown,
        AppLocalizations.of(context)!.ignore,
        null,
      );
    }

    return CustomContainer(
      img: AppImages.thumbDown,
      text: isIgnored
          ? AppLocalizations.of(context)!.ignored
          : AppLocalizations.of(context)!.ignore,
      onTap: () => _showIgnoreDialog(context, isIgnored),
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
    reportDialog(
      context: context,
      userId: userId,
      isReported: isReported,
      question: AppLocalizations.of(context)!.unreportedBeforeIgnore,
      questionButton: AppLocalizations.of(context)!.cancelReport,
      afterSuccess: () => onUserStateChangedReported?.call(),
    );
  }

  void _showIgnoreDialog(BuildContext context, bool isIgnored) {
    ignoreDialog(
      afterSuccess: () => onUserStateChanged?.call(),
      context: context,
      message: isIgnored
          ? AppLocalizations.of(context)!.sureUnignoreQu
          : AppLocalizations.of(context)!.sureIgnoreQu,
      textButton: isIgnored
          ? AppLocalizations.of(context)!.unignoreButton
          : AppLocalizations.of(context)!.yesIgnore,
      userId: userId,
    );
  }
}
