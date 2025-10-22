import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/ignore_dialog.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/report_dialog.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeButton extends StatelessWidget {
  final int userId;
  final UsersDataModel? currentUser;
  final VoidCallback? onUserStateChanged;
  final VoidCallback? onUserStateChangedReported;

  const LikeButton({
    super.key,
    required this.userId,
    this.currentUser,
    this.onUserStateChanged,
    this.onUserStateChangedReported,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
      listenWhen: (context, current) =>
          current is LikeUserLoading ||
          current is LikeUserFailure ||
          current is LikeUserSuccess,
      listener: (context, state) => _handleLikeState(context, state),
      child: _buildLikeButton(context),
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    final isReported = currentUser?.isReported ?? false;
    final isBlocked = currentUser?.isBlocked ?? false;
    final isIgnored = currentUser?.isIgnore ?? false;
    final isFavorite = currentUser?.isFavorite ?? false;

    if (isReported) {
      return _buildDisabledButton(
        context,
        AppImages.like,
        AppLocalizations.of(context)!.interest,
        () => _showReportDialog(context, true),
      );
    }

    if (isBlocked) {
      return _buildDisabledButton(
        context,
        AppImages.like,
        AppLocalizations.of(context)!.interest,
        null,
      );
    }

    if (isIgnored) {
      return _buildDisabledButton(
        context,
        AppImages.like,
        AppLocalizations.of(context)!.interest,
        () => _showIgnoreDialog(context, true),
      );
    }

    return CustomContainer(
      img: AppImages.like,
      text: isFavorite
          ? AppLocalizations.of(context)!.liked
          : AppLocalizations.of(context)!.interest,
      onTap: () => context.read<ProfileDetailsCubit>().likeUser(userId),
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

  void _handleLikeState(BuildContext context, ProfileDetailsState state) {
    if (state is LikeUserLoading) {
      loadingDialog(context);
    } else if (state is LikeUserFailure) {
      context.pop();
      errorDialog(context: context, error: state.error);
    } else if (state is LikeUserSuccess) {
      context.pop();
      onUserStateChanged?.call();
      context.read<ProfileDetailsCubit>().getProfileDetails(userId);
      successDialog(
        context: context,
        message: state.profileDetailsActionResponseModel.message ??
            AppLocalizations.of(context)!.liked,
        onPressed: () => context.pop(),
      );
    }
  }

  void _showReportDialog(BuildContext context, bool isReported) {
    reportDialog(
      afterSuccess: () => onUserStateChangedReported?.call(),
      context: context,
      userId: userId,
      isReported: isReported,
      question: AppLocalizations.of(context)!.unreportBeforeLike,
      questionButton: AppLocalizations.of(context)!.cancelReport,
    );
  }

  void _showIgnoreDialog(BuildContext context, bool isIgnored) {
    ignoreDialog(
      afterSuccess: () => onUserStateChanged?.call(),
      context: context,
      message: AppLocalizations.of(context)!.unignorePersonQu,
      textButton: AppLocalizations.of(context)!.unignoreButton,
      userId: userId,
    );
  }
}
