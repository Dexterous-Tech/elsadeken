import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/delete/delete_dialog.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helper/app_images.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/spacing.dart';

class DeleteProfile extends StatelessWidget {
  const DeleteProfile({super.key, required this.isLoading});

  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        deleteProfileDialog(context);
      },
      child: Row(
        textDirection: LocalizationService.instance.textDirection,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50).r,
            child: Image.asset(
              AppImages.blockUserIcon,
              width: 50.w,
              height: 50.h,
            ),
          ),
          horizontalSpace(16),
          Text(
            AppLocalizations.of(context)!.deleteMyAccount,
            style: AppTextStyles.font26BlackBoldLamaSans
                .copyWith(color: AppColors.coralRed, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
