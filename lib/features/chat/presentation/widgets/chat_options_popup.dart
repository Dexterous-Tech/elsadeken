import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:elsadeken/core/services/localization_service.dart';

class ChatOptionsPopup extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onMute;
  final VoidCallback onBlock;
  final VoidCallback onAddToFavorites;
  final bool isChatFavorite;
  final bool isChatReported;
  final bool isChatMuted;
  final bool isInFavoritesList;

  const ChatOptionsPopup({
    Key? key,
    required this.onDelete,
    required this.onMute,
    required this.onBlock,
    required this.onAddToFavorites,
    this.isChatFavorite = false,
    this.isChatReported = false,
    this.isChatMuted = false,
    this.isInFavoritesList = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 31.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10).r,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Delete Chat
                _buildOptionItem(
                  context,
                  imagePath: 'assets/images/icons/trash.png',
                  text: AppLocalizations.of(context)!.deleteChat,
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: AppColors.grey,
                ),
                // Mute/Unmute
                _buildOptionItem(
                  context,
                  imagePath: 'assets/images/icons/mute.png',
                  text: isChatMuted 
                      ? AppLocalizations.of(context)!.unmuteChat 
                      : AppLocalizations.of(context)!.muteChat,
                  onTap: () {
                    Navigator.pop(context);
                    onMute();
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: AppColors.grey,
                ),
                // Block User / Unreport User
                _buildOptionItem(
                  context,
                  imagePath: 'assets/images/icons/block-user.png',
                  text: isChatReported 
                      ? AppLocalizations.of(context)!.unreportUser 
                      : AppLocalizations.of(context)!.blockUser,
                  onTap: () {
                    Navigator.pop(context);
                    onBlock();
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: AppColors.grey,
                ),
                // Add to Favorites / Remove from Favorites
                _buildOptionItem(
                  context,
                  imagePath: 'assets/images/icons/heart.png',
                  text: _getFavoritesText(context),
                  onTap: () {
                    Navigator.pop(context);
                    onAddToFavorites();
                  },
                  iconColor: isChatFavorite ? Colors.red : null,
                ),
              ],
            ),
          ),
          verticalSpace(10),
          // Cancel Button
          CustomElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textButton: AppLocalizations.of(context)!.cancel,
            height: 56.h,
            radius: 10.r,
            styleTextButton: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.jet,
            ),
          ),
        ],
      ),
    );
  }

  String _getFavoritesText(BuildContext context) {
    if (isInFavoritesList) {
      // In favorites list, always show "Remove from Favorites"
      return AppLocalizations.of(context)!.removeFromFavorites;
    } else {
      // In all chats list, show based on current favorite status
      return isChatFavorite 
          ? AppLocalizations.of(context)!.removeFromFavorites 
          : AppLocalizations.of(context)!.addToFavorites;
    }
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required String imagePath,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            verticalSpace(24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: LocalizationService.instance.textDirection,
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: AppTextStyles.font18BabyBlueRegularLamaSans,
                      textDirection: LocalizationService.instance.textDirection,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  horizontalSpace(16),
                  Image.asset(
                    imagePath,
                    width: 24.w,
                    height: 24.w,
                    color: iconColor,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            verticalSpace(24),
          ],
        ),
      ),
    );
  }
}
