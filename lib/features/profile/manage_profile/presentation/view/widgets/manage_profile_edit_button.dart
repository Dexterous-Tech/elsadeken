import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProfileEditButton extends StatelessWidget {
  const ManageProfileEditButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: CustomElevatedButton(
          backgroundColor: AppColors.meatBrown,
          height: 50.h,
          radius: 30,
          onPressed: onPressed ?? () {},
          textButton: AppLocalizations.of(context)!.modify,
        ));
  }
}
