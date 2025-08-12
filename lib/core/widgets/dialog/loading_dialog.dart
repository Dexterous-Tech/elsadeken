import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/dialog/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../helper/app_lottie.dart';

void loadingDialog(BuildContext context) {
  customDialog(
    context: context,
    backgroundColor: AppColors.white,
    dialogContent: Center(
      child: Lottie.asset(AppLottie.loadingLottie),
    ),
  );
}
