import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/ignore_dialog.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/report_dialog.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_state.dart';

class MessageButton extends StatelessWidget {
  final int userId;
  final UsersDataModel? currentUser;
  final UsersDataModel? user;
  final VoidCallback? onUserStateChanged;
  final VoidCallback? onUserStateChangedReported;

  const MessageButton({
    super.key,
    required this.userId,
    this.currentUser,
    this.user,
    this.onUserStateChanged,
    this.onUserStateChangedReported,
  });

  @override
  Widget build(BuildContext context) {
    final isReported = currentUser?.isReported ?? false;
    final isBlocked = currentUser?.isBlocked ?? false;
    final isIgnored = currentUser?.isIgnore ?? false;

    if (isReported) {
      return _buildDisabledButton(
        context,
        AppImages.message,
        AppLocalizations.of(context)!.chats,
        () => _showReportDialog(context, true),
      );
    }

    if (isBlocked) {
      return _buildDisabledButton(
        context,
        AppImages.message,
        AppLocalizations.of(context)!.chats,
        null,
      );
    }

    if (isIgnored) {
      return _buildDisabledButton(
        context,
        AppImages.message,
        AppLocalizations.of(context)!.chats,
        () => _showIgnoreDialog(context),
      );
    }

    return GestureDetector(
      onTap: () => _navigateToChat(context),
      child: CustomContainer(
        img: AppImages.message,
        text: AppLocalizations.of(context)!.chats,
      ),
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
      afterSuccess: () => onUserStateChangedReported?.call(),
      context: context,
      userId: userId,
      isReported: isReported,
      question: AppLocalizations.of(context)!.unreportedBeforeMessage,
      questionButton: AppLocalizations.of(context)!.cancelReport,
    );
  }

  void _showIgnoreDialog(BuildContext context) {
    ignoreDialog(
      afterSuccess: () => onUserStateChanged?.call(),
      context: context,
      message: AppLocalizations.of(context)!.messageUnignoreQu,
      textButton: AppLocalizations.of(context)!.unignoreButton,
      userId: userId,
    );
  }

  Future<void> _navigateToChat(BuildContext context) async {
    try {
      final chatListCubit = context.read<ChatListCubit>();

      if (chatListCubit.state is! ChatListLoaded) {
        await chatListCubit.forceRefreshChatList();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final existingChatRoom = chatListCubit.findExistingChatRoom(userId);

      if (existingChatRoom != null) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.chatConversationScreen,
            arguments: {"chatRoom": existingChatRoom},
          );
        }
      } else {
        if (context.mounted) {
          final userData = _getUserData(context);
          Navigator.pushNamed(
            context,
            AppRoutes.chatConversationScreen,
            arguments: {
              "chatRoom": ChatRoomModel.fromUser(
                userId: userId,
                userName: userData['name'] ?? 'User',
                userImage: userData['image'] ?? '',
              ),
            },
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.chatConversationScreen,
          arguments: {
            "chatRoom": ChatRoomModel.fromUser(
              userId: userId,
              userName: user?.name ?? 'User',
              userImage: user?.image ?? '',
            ),
          },
        );
      }
    }
  }

  Map<String, String> _getUserData(BuildContext context) {
    final cubit = context.read<ProfileDetailsCubit>();
    final state = cubit.state;

    String userName = 'User';
    String userImage = '';

    if (state is GetProfileDetailsSuccess) {
      final userData = state.profileDetailsResponseModel.data;
      if (userData != null) {
        userName = userData.name ?? 'User';
        userImage = userData.image ?? '';
      }
    } else if (user != null) {
      userName = user!.name ?? 'User';
      userImage = user!.image ?? '';
    }

    return {'name': userName, 'image': userImage};
  }
}
