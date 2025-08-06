import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class ManageProfileIconDropMenu extends StatelessWidget {
  const ManageProfileIconDropMenu({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Text(
          title,
          style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(context),
        ),
        horizontalSpace(9),
        Transform.rotate(
          angle: -1.5708, // 90 degrees in radians (π/2)
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.philippineBronze,
            size: 16,
          ),
        ),
      ],
    );
  }
}
