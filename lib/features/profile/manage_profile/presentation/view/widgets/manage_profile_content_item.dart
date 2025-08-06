import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:flutter/material.dart';

class ManageProfileContentItem extends StatelessWidget {
  const ManageProfileContentItem({
    super.key,
    required this.title,
    required this.itemContent,
  });

  final String title;
  final Widget itemContent;
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.font18JetBoldPlexSans(
            context,
          ).copyWith(fontWeight: FontWeightHelper.regular),
        ),
        itemContent,
      ],
    );
  }
}
