import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final int userId;

  const ShareButton({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
      listenWhen: (context, current) =>
          current is ShareUserLoading ||
          current is ShareUserFailure ||
          current is ShareUserSuccess,
      listener: (context, state) => _handleShareState(context, state),
      child: CustomContainer(
        img: AppImages.share,
        text: AppLocalizations.of(context)!.share,
        onTap: () => context.read<ProfileDetailsCubit>().shareUser(userId),
      ),
    );
  }

  void _handleShareState(BuildContext context, ProfileDetailsState state) {
    if (state is ShareUserFailure) {
      context.pop();
      errorDialog(context: context, error: state.error);
    } else if (state is ShareUserSuccess) {
      _handleShareSuccess(context, state);
    }
  }

  void _handleShareSuccess(BuildContext context, ShareUserSuccess state) {
    final shareUrl = state.profileDetailsActionResponseModel.data?.shareUrl;

    if (shareUrl != null && shareUrl.isNotEmpty) {
      SharePlus.instance.share(
        ShareParams(
          text: '${AppLocalizations.of(context)!.checkOutProfile}: \n$shareUrl',
          subject: 'User Profile',
        ),
      );
    } else {
      errorDialog(
        context: context,
        error: AppLocalizations.of(context)!.noShareLinkAvailable,
      );
    }
  }
}
