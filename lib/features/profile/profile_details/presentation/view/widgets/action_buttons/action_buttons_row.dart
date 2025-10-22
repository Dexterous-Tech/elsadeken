import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/action_buttons/ignore_button.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/action_buttons/like_button.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/action_buttons/message_button.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/action_buttons/report_button.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/action_buttons/share_button.dart';
import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final int userId;
  final UsersDataModel? currentUser;
  final UsersDataModel? user;
  final VoidCallback? onUserStateChanged;

  const ActionButtonsRow({
    super.key,
    required this.userId,
    this.currentUser,
    this.user,
    this.onUserStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: LocalizationService.instance.textDirection,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ShareButton(userId: userId),
        LikeButton(
          userId: userId,
          currentUser: currentUser,
          onUserStateChanged: onUserStateChanged,
        ),
        IgnoreButton(
          userId: userId,
          currentUser: currentUser,
          onUserStateChanged: onUserStateChanged,
        ),
        MessageButton(
          userId: userId,
          currentUser: currentUser,
          user: user,
          onUserStateChanged: onUserStateChanged,
        ),
        ReportButton(
          userId: userId,
          currentUser: currentUser,
        ),
      ],
    );
  }
}
