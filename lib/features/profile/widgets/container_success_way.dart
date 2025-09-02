import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_styles.dart';

class ContainerSuccessWay extends StatelessWidget {
  const ContainerSuccessWay({super.key, this.text});
  

  final String ?text;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lighterOrange,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Center(
        child: Text(
          text ?? AppLocalizations.of(context)!.successGuide,
          style: AppTextStyles.font20LightOrangeMediumLamaSans
              .copyWith(color: AppColors.jasper),
        ),
      ),
    );
  }
}
